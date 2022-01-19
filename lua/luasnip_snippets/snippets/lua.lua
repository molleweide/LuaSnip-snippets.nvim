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
local events = require("luasnip.util.events")

-- print("... in lua -> `" .. ... .. "`")

local utils = require("luasnip_snippets.utils")

return {
    lua = {
    -- LEARNING ---------

    -- isn indent node >>
    -- START: UNDERSTAND
    -- arstss
    -- END: UNDERSTAND

    -- s("understand", {
    --     t("text_node"),
    -- }),

    -- PRINTS -----------

    s("lua print var", {
    t("print(\""),
    i(1, "desrc"),
    t(": \" .. "),
    i(2, "the_variable"),
    t(")"),
    }),


    --------------------------------------------
    ---       lua function definitions       ---
    --------------------------------------------

    -- TODO: convert to lua
	-- Very long example for a java class.
	s("fndef", {
	d(6, utils.luadocsnip, { 2, 4, 5 }),
	t({ "", "" }),
	c(1, {
	t("public "),
	t("private "),
	}),
	c(2, {
	t("void"),
	t("String"),
	t("char"),
	t("int"),
	t("double"),
	t("boolean"),
	i(nil, ""),
	}),
	t(" "),
	i(3, "myFunc"),
	t("("),
	i(4),
	t(")"),
	c(5, {
	t(""),
	sn(nil, {
	t({ "", " throws " }),
	i(1),
	}),
	}),
	t({ " {", "\t" }),
	i(0),
	t({ "", "}" }),
	}),

    -- inline
    -- callback
    -- anonymous
    -- table anonymous
    --
    -- lua doc params

    s("fn basic", {
	t("-- @param: "), f(utils.copy, 2),
	t({"","local "}), i(1), t(" = function("),i(2,"fn param"),t({ ")", "\t" }),
	i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
	t({ "", "end" }),
	}),

    s("fn module", {
    -- make new line into snippet
	t("-- @param: "), f(utils.copy, 3), t({"",""}),
	i(1, "modname"), t("."), i(2, "fnname"), t(" = function("),i(3,"fn param"),t({ ")", "\t" }),
	i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
	t({ "", "end" }),
	}),

	-------------------------------------
	---       lua function call       ---
	-------------------------------------

    -- dynamic extensible params
    -- table

	------------------------------
	---       lua tables       ---
	------------------------------
    -- key value pairs
    -- named sub tables
    --




	--------------------------------
	---       conditionals       ---
	--------------------------------
	-- if nil
	-- elseif

	s({trig="if basic", wordTrig=true}, {
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

    -- LOOPS ----------------------------------------

	s("for", {
	t"for ", c(1, {
	sn(nil, {i(1, "k"), t", ", i(2, "v"), t" in ", c(3, {t"pairs", t"ipairs"}), t"(", i(4), t")"}),
	sn(nil, {i(1, "i"), t" = ", i(2), t", ", i(3), })
	}), t{" do", "\t"}, i(0), t{"", "end"}
	})

	---------------------------
	---       strings       ---
	---------------------------
	-- if fs.file_exists(string.format("%s/doc/doom_nvim.norg", system.doom_root)) then
	--


	-------------------------
	---       regex       ---
	-------------------------
	-- for release in doom_releases:gmatch("[^\r\n]+") do
	-- for release_hash, version in version_info:gmatch("(%w+)%s(%w+%W+%w+%W+%w+)") do
	-- local backup_commit = fs.read_file(rolling_backup):gsub("[\r\n]+", "")
	-- local start_line = vim.fn.getline(vim.v.foldstart):gsub("\t", ("\t"):rep(vim.opt.tabstop:get()))
	-- local start_line = vim.fn.getline(vim.v.foldstart):gsub("\t", ("\t"):rep(vim.opt.tabstop:get()))
	-- sorted_releases[#releases + 1 - idx] = release:gsub("refs/tags/", "")

    -----------------------
    ---       i/o       ---
    -----------------------
	-- fs.write_file(releases_database_path, release .. "\n", "a+")
}
}
