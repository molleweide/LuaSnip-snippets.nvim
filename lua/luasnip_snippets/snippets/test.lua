local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local isn = ls.indent_snippet_node
local events = require("luasnip.util.events")

local utils = require("luasnip_snippets.utils")

-- @param: cursline, trigmatch, captures
local co = function(cursline, trigmatch, captures)
    -- condition = function(line_to_cursor, matched_trigger, captures)
    print("cursline: " .. cursline)
    print("trigmatch: " .. trigmatch)
    print(vim.inspect(captures))

    return true
end

local function lines(args, snip, old_state, initial_text)
	local nodes = {}
	if not old_state then old_state = {} end

	-- count is nil for invalid input.
	local count = tonumber(args[1][1])
	-- Make sure there's a number in args[1].
	if count then
		for j=1, count do
			local iNode
			if old_state and old_state[j] then
				-- old_text is used internally to determine whether
				-- dependents should be updated. It is updated whenever the
				-- node is left, but remains valid when the node is no
				-- longer 'rendered', whereas node:get_text() grabs the text
				-- directly from the node.
				iNode = i(j, old_state[j].old_text)
			else
			    iNode = i(j, initial_text)
			end
			nodes[2*j-1] = iNode

			-- linebreak
			nodes[2*j] = t({"",""})
			-- Store insertNode in old_state, potentially overwriting older
			-- nodes.
			old_state[j] = iNode
		end
	else
		nodes[1] = t("Enter a number!")
	end

	local snip = sn(nil, nodes)
	snip.old_state = old_state
	return snip
end



return {
    all = {
        s("trig1", {
 	        i(1),
	        i(2, {"first_line_of_second", "second_line_of_second"}),
 	        f(function(args, snip, user_arg_1) return args[2][1] .. user_arg_1 end,
 	            {1, 2},
 	            "Will be appended to text from i(0)"),
 	        i(0)
        }),

        s("isn2", {
	        isn(1, t({"//This is", "A multiline", "comment"}), "$PARENT_INDENT//")
        }),

        s("trig", c(1, {
 	        t("Ugh boring, a text node"),
 	        i(nil, "At least I can edit something now..."),
 	        f(function(args) return "Still only counts as text!!" end, {})
        })),

        -- s({trig2 = "b(%d)", regTrig = true},
	    --  f(function(args, snip) return
	    --   "Captured Text: " .. snip.captures[1] .. "." end, {})
        -- )
	    s("test dynamic", {
	        t("AAA "),
	        d(1, utils.date_input, {}, { user_args = "%A, %B %d of %Y" }),
	        t(" BBB "),
	        i(2, "second"),
	        t(". "),
	    }),

	    -- advanced test
	    s(
	        { -- arg 1
	            trig = "testadvanced",
	            name = "test advanced snippet",
	            dscr = "testing all features of luasnip",
	            wordTrig = true,
	            regTrig = false,
	            -- docstring = "",
	            -- docTrig = "",
	            hidden = false,
	        },
	        { -- arg 2
	            f(function(args, snip, user_arg_1)
	                if user_arg_1 ~= nil then
	                    return user_arg_1 .. args[1][1] -- .. "\n" .. args[2][1] .. "\n\n"
	                end
	            end,
 	                {3, 2},
 	                "<<<<< "),
	            t({ "AAA ", "" }),
	            i(1, "aaaaa"),
	            t({ "", "BBB", ""}),
	            i(2, "bbbbb"),
	            t({ "", "CCC", ""}),
	            i(3, "ccccc"),
	            f(function(args, snip, user_arg_1) return args[1][1] .. user_arg_1 end,
 	                {1},
 	                " >>>>"),
	        },
	        {
	            condition = co,
	            callbacks = { [2] = { [events.enter] = function() print "2!" end } }
	        }
	    ),

	    s({trig = "b(%d)", regTrig = true},
	        f(function(args, snip) return
	            "Captured Text: " .. snip.captures[1] .. "." end, {})
        ),

        s("trig", {
	        i(1, "1"),
	        -- pos, function, argnodes, user_arg1
	        d(2, lines, {1}, { user_args = "Sample Text" })
        }),


        -----------------------------------------------------------------
        -- EXAMPLES ------------------------------------------------------
        -----------------------------------------------------------------

	    -- Parsing snippets: First parameter: Snippet-Trigger, Second: Snippet body.
	    -- Placeholders are parsed into choices with 1. the placeholder text(as a snippet) and 2. an empty string.
	    -- This means they are not SELECTed like in other editors/Snippet engines.
	    ls.parser.parse_snippet(
	        "lspsyn",
	        "Wow! This ${1:Stuff} really ${2:works. ${3:Well, a bit.}}"
	    ),

	    -- When wordTrig is set to false, snippets may also expand inside other words.
	    ls.parser.parse_snippet(
	        { trig = "te", wordTrig = false },
	        "${1:cond} ? ${2:true} : ${3:false}"
	    ),

	    -- -- When regTrig is set, trig is treated like a pattern, this snippet will expand after any number.
	    -- ls.parser.parse_snippet({ trig = "%d", regTrig = true }, "A Number!!"),

	    -- The last entry of args passed to the user-function is the surrounding snippet.
	    s(
	        { trig = "a%d", regTrig = true },
	        f(function(_, snip)
	            return "Triggered with " .. snip.trigger .. "."
	        end, {})
	    ),

	    -- It's possible to use capture-groups inside regex-triggers.
	    s(
	        { trig = "b(%d)", regTrig = true },
	        f(function(_, snip)
	            return "Captured Text: " .. snip.captures[1] .. "."
	        end, {})
	    ),

	    -- c55456
	    s({ trig = "c(%d+)", regTrig = true }, {
	        t("will only expand for even numbers"),
	    }, {
	            condition = function(line_to_cursor, matched_trigger, captures)
	                return tonumber(captures[1]) % 2 == 0
	            end,
	        }
	    ),

	    -- Short version for applying String transformations using function nodes.
	    s("transform", {
	        l(l._1:match("[^i]*$"):gsub("i", "o"):gsub(" ", "_"):upper(), 1),
	        t({ "", "" }),
	        i(1, "initial text"),
	        t({ "", "" }),
	        -- lambda nodes accept an l._1,2,3,4,5, which in turn accept any string transformations.
	        -- This list will be applied in order to the first node given in the second argument.
	        l(l._1:match("[^i]*$"):gsub("i", "o"):gsub(" ", "_"):upper(), 1),
	    }),

	    s("transform2", {
	        i(1, "initial text"),
	        t("::"),
	        i(2, "replacement for e"),
	        t({ "", "" }),
	        -- Lambdas can also apply transforms USING the text of other nodes:
	        l(l._1:gsub("e", l._2), { 1, 2 }),
	    }),

	    s({ trig = "trafo(%d+)", regTrig = true }, {
	        -- env-variables and captures can also be used:
	        l(l.CAPTURE1:gsub("1", l.TM_FILENAME), {}),
	    }),



	    -- NOTE: here you could use leader bindings i believe to expand?
	    -- Set store_selection_keys = "<Tab>" (for example) in your
	    -- luasnip.config.setup() call to access TM_SELECTED_TEXT. In
	    -- this case, select a URL, hit Tab, then expand this snippet.
	    s("link_url", {
	        t('<a href="'),
	        f(function(_, snip)
	            return snip.env.TM_SELECTED_TEXT[1] or {}
	        end, {}),
	        t('">'),
	        i(1),
	        t("</a>"),
	        i(0),
	    }),


	    -- repeat {1} at r.
	    s("repeat", { i(1, "text"), t({ "", "" }), r(1) }),


	    -- Directly insert the ouput from a function evaluated at runtime.
	    s("part", p(os.date, "%Y")),


	    -- use matchNodes to insert text based on a pattern/function/lambda-evaluation.
        -- st5rst6: contains a number
	    s("mat", {
	        i(1, { "sample_text" }),
	        t(": "),
	        m(1, "%d", "contains a number", "no number :("),
	    }),


	    -- The inserted text defaults to the first capture group/the entire
	    -- match if there are none
        -- acb: acb
	    s("mat2", {
	        i(1, { "sample_text" }),
	        t(": "),
	        m(1, "[abc][abc][abc]"),
	    }),


	    -- It is even possible to apply gsubs' or other transformations
	    -- before matching.
        -- ar3srstrst42: contains a number that isn't 1, 2 or 3!
	    s("mat3", {
	        i(1, { "sample_text" }),
	        t(": "),
	        m(
	            1,
	            l._1:gsub("[123]", ""):match("%d"),
	            "contains a number that isn't 1, 2 or 3!"
	        ),
	    }),

        -- ????????????
	    -- `match` also accepts a function, which in turn accepts a string
	    -- (text in node, \n-concatted) and returns any non-nil value to match.
	    -- If that value is a string, it is used for the default-inserted text.
	    s("mat4", {
	        i(1, { "sample_text" }),
	        t(": "),
	        m(1, function(text)
	            return (#text % 2 == 0 and text) or nil
	        end),
	    }),


	    -- The nonempty-node inserts text depending on whether the arg-node is
	    -- empty.
	    s("nempty", {
	        i(1, "sample_text"),
	        n(1, "i(1) is not empty!"),
	    }),


	    -- dynamic lambdas work exactly like regular lambdas, except that they
	    -- don't return a textNode, but a dynamicNode containing one insertNode.
	    -- This makes it easier to dynamically set preset-text for insertNodes.
	    s("dl1", {
	        i(1, "sample_text"),
	        t({ ":", "" }),
	        dl(2, l._1, 1),
	    }),


	    -- Obviously, it's also possible to apply transformations, just like lambdas.
	    s("dl2", {
	        i(1, "sample_text"),
	        i(2, "sample_text_2"),
	        t({ "", "" }),
	        dl(3, l._1:gsub("\n", " linebreak ") .. l._2, { 1, 2 }),
	    }),


        -- ??? this one seems to expand regardless
	    -- Using the condition, it's possible to allow expansion only in specific cases.
	    s("cond", {
	        t("will only expand in c-style comments"),
	    }, {
	            condition = function(line_to_cursor, matched_trigger, captures)
	                -- optional whitespace followed by //
	                return line_to_cursor:match("%s*//")
	            end,
	        }
	    ),


	    -- there's some built-in conditions in "luasnip.extras.conditions".
	    s("cond2", {
	        t("will only expand at the beginning of the line"),
	    }, {
	            condition = conds.line_begin,
	        }
	    ),


        -- Alternative printf-like notation for defining snippets. It uses format
	    -- string with placeholders similar to the ones used with Python's .format().
	    s(
	        "fmt1",
	        fmt("To {title} {} {}.", {
	            i(2, "Name"),
	            i(3, "Surname"),
	            title = c(1, { t("Mr."), t("Ms.") }),
	        })
	    ),

	    -- To escape delimiters use double them, e.g. `{}` -> `{{}}`.
	    -- Multi-line format strings by default have empty first/last line removed.
	    -- Indent common to all lines is also removed. Use the third `opts` argument
	    -- to control this behaviour.
	    s(
	        "fmt2",
	        fmt(
	            [[
	            foo({1}, {3}) {{
	            return {2} * {4}
	            }}
	            ]],
	            {
	                i(1, "x"),
	                r(1),
	                i(2, "y"),
	                r(2),
	            }
	        )
	    ),

        -- Empty placeholders are numbered automatically starting from 1 or the last
	    -- value of a numbered placeholder. Named placeholders do not affect numbering.
	    s(
	        "fmt3",
	        fmt("{} {a} {} {1} {}", {
	            t("1"),
	            t("2"),
	            a = t("A"),
	        })
	    ),

	    -- The delimiters can be changed from the default `{}` to something else.
	    s("fmt4", fmt("foo() { return []; }", i(1, "x"), { delimiters = "[]" })),

	    -- `fmta` is a convenient wrapper that uses `<>` instead of `{}`.
	    s("fmt5", fmta("foo() { return <>; }", i(1, "x"))),

	    -- By default all args must be used. Use strict=false to disable the check
	    s(
	        "fmt6",
	        fmt("use {} only", { t("this"), t("not this") }, { strict = false })
	    ),


        -----------------------------------------------------------------
        -- lemon tests
        -----------------------------------------------------------------

        s("test1", {
	        i(1, "ቒ"), i(3), i(2), i(0), i(4)
	    }),

	    s({ trig = "tt" }, {
	        t { "╔" },
	        f(function() return {"e"} end, {}),   -- Seems related to having `t` and then `f` with only t it works fine
	        t { "1", "2" },
	        i(0),
	    }),

	    s({trig = "trig"}, {
	        t{"lel", "\t"},
	        i(1, "lol"), t{"lel", "\t"},
	        t{"lel", "lel"}
	    }, {callbacks = {
	            [-1] = {
	                [events.enter] = function() print("1!!") end
	            },
	            [0] = {
	                [events.enter] = function(node)
	                    vim.schedule(function()
	                        node.parent.snippet:exit()
	                        ls.session.current_nodes[vim.api.nvim_get_current_buf()] = nil
	                    end)
	                end
	            }
	        }
	        }
	    ),
    }
}
