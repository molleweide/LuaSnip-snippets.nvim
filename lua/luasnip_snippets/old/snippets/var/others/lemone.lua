local ls = require("luasnip")
local s = ls.s
local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
local c = ls.c
local d = ls.d
local pi = ls.parent_indexer
local isn = require("luasnip.nodes.snippet").ISN
local psn = require("luasnip.nodes.snippet").PSN
local l = require'luasnip.extras'.l
local r = require'luasnip.extras'.rep
local p = require("luasnip.extras").partial
local types = require("luasnip.util.types")
local events = require("luasnip.util.events")
local util = require("luasnip.util.util")

ls.config.setup({
	history = true,
	-- updateevents = 'InsertLeave',
	updateevents = "InsertLeave",
	enable_autosnippets = true,
	region_check_events = "CursorHold",
	delete_check_events = "TextChanged,InsertEnter",
	store_selection_keys = "<Tab>",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = {{"●", "GruvboxOrange"}},
			}
		}
	},
	-- parser_nested_assembler = function(_, snippet)
	-- 	local select = function(snip, no_move)
	-- 		snip.parent:enter_node(snip.indx)
	-- 		-- upon deletion, inner extmarks should shift to end of
	-- 		-- placeholder-text.
	-- 		for _, node in ipairs(snip.nodes) do
	-- 			node:set_mark_rgrav(true, true)
	-- 		end

	-- 		if not no_move then
	-- 			vim.api.nvim_feedkeys(
	-- 				vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
	-- 				"n",
	-- 				true
	-- 			)
	-- 			local pos_begin, pos_end = snip.mark:pos_begin_end()
	-- 			util.normal_move_on(pos_begin)
	-- 			vim.api.nvim_feedkeys(
	-- 				vim.api.nvim_replace_termcodes("v", true, false, true),
	-- 				"n",
	-- 				true
	-- 			)
	-- 			util.normal_move_before(pos_end)
	-- 			vim.api.nvim_feedkeys(
	-- 				vim.api.nvim_replace_termcodes("o<C-G>", true, false, true),
	-- 				"n",
	-- 				true
	-- 			)
	-- 		end
	-- 	end
	-- 	function snippet:jump_into(dir, no_move)
	-- 		if self.active then
	-- 			if dir == 1 then
	-- 				self:input_leave()
	-- 				return self.next:jump_into(dir, no_move)
	-- 			else
	-- 				select(self, no_move)
	-- 				return self
	-- 			end
	-- 		else
	-- 			self:input_enter()
	-- 			if dir == 1 then
	-- 				select(self, no_move)
	-- 				return self
	-- 			else
	-- 				return self.inner_last:jump_into(dir, no_move)
	-- 			end
	-- 		end
	-- 	end
	-- 	-- this is called only if the snippet is currently selected.
	-- 	function snippet:jump_from(dir, no_move)
	-- 		if dir == 1 then
	-- 			return self.inner_first:jump_into(dir, no_move)
	-- 		else
	-- 			self:input_leave()
	-- 			return self.prev:jump_into(dir, no_move)
	-- 		end
	-- 	end
	-- 	return snippet
	-- end
})

function insert_popup(snippet)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_text(buf, 0,0,0,0, {"˯"})
	for _, node in ipairs(snippet.insert_nodes) do
		local win = vim.api.nvim_open_win(buf, false, {anchor = "SW", relative = "win", width=1, height=1, bufpos=node.mark:pos_begin(), style="minimal"})
		vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Normal")
	end
end

local current_win
function choice_popup(choiceNode)
	vim.schedule(function()
		local buf = vim.api.nvim_create_buf(false, true)
		local buf_text = {}
		for _, node in ipairs(choiceNode.choices) do
			vim.list_extend(buf_text, node:get_docstring())
		end
		vim.api.nvim_buf_set_text(buf, 0,0,0,0, buf_text)
		local w, h = vim.lsp.util._make_floating_popup_size(buf_text)
		local r, c = unpack(choiceNode.mark:pos_begin())
		current_win = vim.api.nvim_open_win(buf, false, {
			relative = "cursor", width=w, height=h, row = 1, col = 0, style="minimal"})
		-- vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Normal")
	end)
end

function choice_popup_close()
	if current_win then
		-- force-close current choice popup.
		vim.api.nvim_win_close(current_win, true)
	end
end

-- vim.cmd([[
-- augroup choice_popup
-- au!
-- au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
-- au User LuasnipChoiceNodeLeave lua choice_popup_close()
-- au User LuasnipChangeChoice lua choice_popup_close() choice_popup(require("luasnip").session.event_node)
-- augroup END
-- ]])

local function copy(args)
	return args[1]
end

local function char_count_same(c1, c2)
	local line = vim.api.nvim_get_current_line()
	local _, ct1 = string.gsub(line, '%'..c1, '')
	local _, ct2 = string.gsub(line, '%'..c2, '')
	return ct1 == ct2
end

local function even_count(c)
	local line = vim.api.nvim_get_current_line()
	local _, ct = string.gsub(line, c, '')
	return ct % 2 == 0
end

local function neg(fn, ...)
	return not fn(...)
end

local function jdocsnip(args, _, old_state)
	local nodes = {
		t({"/**"," * "}),
		old_state and i(1, old_state.descr:get_text()) or i(1, {"A short Description"}),
		t({"", ""})
	}

	-- These will be merged with the snippet; that way, should the snippet be updated,
	-- some user input eg. text can be referred to in the new snippet.
	local param_nodes = {
		descr = nodes[2]
	}

	-- At least one param.
	if string.find(args[2][1], " ") then
		vim.list_extend(nodes, {t({" * ", ""})})
	end

	local insert = 2
	for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
		-- Get actual name parameter.
		arg = vim.split(arg, " ", true)[2]
		if arg then
			arg = arg:gsub(",", "")
			local inode
			-- if there was some text in this parameter, use it as static_text for this new snippet.
			if old_state and old_state["arg"..arg] then
				inode = i(insert, old_state["arg"..arg]:get_text())
			else
				inode = i(insert)
			end
			vim.list_extend(nodes, {t({" * @param "..arg.." "}), inode, t({"", ""})})
			param_nodes["arg"..arg] = inode

			insert = insert + 1
		end
	end

	if args[1][1] ~= "void" then
		local inode
		if old_state and old_state.ret then
			inode = i(insert, old_state.ret:get_text())
		else
			inode = i(insert)
		end

		vim.list_extend(nodes, {t({" * ", " * @return "}), inode, t({"", ""})})
		param_nodes.ret = inode
		insert = insert + 1
	end

	if vim.tbl_count(args[3]) ~= 1 then
		local exc = string.gsub(args[3][2], " throws ", "")
		local ins
		if old_state and old_state.ex then
			ins = i(insert, old_state.ex:get_text())
		else
			ins = i(insert)
		end
		vim.list_extend(nodes, {t({" * ", " * @throws "..exc.." "}), ins, t({"", ""})})
		param_nodes.ex = ins
		insert = insert + 1
	end

	vim.list_extend(nodes, {t({" */"})})

	local snip = sn(nil, nodes)
	-- Error on attempting overwrite.
	snip.old_state = param_nodes
	return snip
end

local rec_ls
rec_ls = function()
	return sn(nil, {
		c(1, {
			t({""}),
			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}),
		}),
	})
end

local function capture_insert(args, snip, _, capture_indx, pre_text, post_text)
	return sn(nil, {i(1, {(pre_text or "") .. snip.captures[capture_indx] .. (post_text or "")})})
end



local function get_prefix()
    return tostring(vim.fn.line("."))
end

ls.snippets = {
	lua = {
		s({trig="if", wordTrig=true}, {
			t({"if "}),
			i(1),
			t({" then", "\t"}),
			i(0),
			t({"", "end"})
		}),
		s({trig="ee", wordTrig=true}, {
			t({"else", "\t"}),
			i(0),
		}),
		s("for", {
			t"for ", c(1, {
				sn(nil, {i(1, "k"), t", ", i(2, "v"), t" in ", c(3, {t"pairs", t"ipairs"}), t"(", i(4), t")"}),
				sn(nil, {i(1, "i"), t" = ", i(2), t", ", i(3), })
			}), t{" do", "\t"}, i(0), t{"", "end"}
		})
	},
	tex = {
		ls.parser.parse_snippet({trig = ";"}, "\\$$1\\$$0"),
		s({trig = "(s*)sec", wordTrig = true, regTrig = true}, {
			f(function(args) return {"\\"..string.rep("sub", string.len(args[1].captures[1]))} end, {}),
			t({"section{"}), i(1), t({"}", ""}), i(0)
		}),
		ls.parser.parse_snippet({trig = "beg", wordTrig = true}, "\\begin{$1}\n\t$2\n\\end{$1}"),
		ls.parser.parse_snippet({trig = "beq", wordTrig = true}, "\\begin{equation*}\n\t$1\n\\end{equation*}"),
		ls.parser.parse_snippet({trig = "bal", wordTrig = true}, "\\begin{aligned}\n\t$1\n\\end{aligned}"),
		ls.parser.parse_snippet({trig = "ab", wordTrig = true}, "\\langle $1 \\rangle"),
		ls.parser.parse_snippet({trig = "lra", wordTrig = true}, "\\leftrightarrow"),
		ls.parser.parse_snippet({trig = "Lra", wordTrig = true}, "\\Leftrightarrow"),
		ls.parser.parse_snippet({trig = "fr", wordTrig = true}, "\\frac{$1}{$2}"),
		ls.parser.parse_snippet({trig = "tr", wordTrig = true}, "\\item $1"),
		ls.parser.parse_snippet({trig = "abs", wordTrig = true}, "\\|$1\\|"),
		s("ls", {
			t({"\\begin{itemize}",
			"\t\\item "}), i(1), d(2, rec_ls, {}),
			t({"", "\\end{itemize}"}), i(0)
		})
	},
	cpp = {
		ls.parser.parse_snippet({trig = "if", wordTrig = true}, "if ($1)\n\t$2\n$0"),
		ls.parser.parse_snippet({trig = "for", wordTrig = true}, "for ($1 : $2)\n\t$3\n$0"),
		s({trig = "for(%w+)", wordTrig = true, regTrig = true}, {
			t({"for ("}), d(1, capture_insert, {}, 1, "int ", " = 0"), t({"; "}),
			f(function(args, snip) return {snip.captures[1]} end, {}), c(2, {sn(nil, {t({" != "}), i(1)}), i(nil)}), t({"; "}),
			d(3, capture_insert, {}, 1, "++"), t({")", "\t"}), i(4), t({"", ""}), i(0)
		})
	}
}

-- require("luasnip.loaders.from_vscode").lazy_load()
