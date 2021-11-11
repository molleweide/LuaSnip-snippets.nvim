local ls = require("luasnip")
-- some shorthands...
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
local pi = ls.parent_indexer
local isn = require("luasnip.nodes.snippet").ISN
local psn = require("luasnip.nodes.snippet").PSN
local l = require'luasnip.extras'.l
local r = require'luasnip.extras'.rep
local p = require("luasnip.extras").partial
local types = require("luasnip.util.types")
local events = require("luasnip.util.events")
local su = require("luasnip.util.util")

return {
	tex = {
        -- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
        -- \item as necessary by utilizing a choiceNode.
        s("ls", {
            t({ "\\begin{itemize}", "\t\\item " }),
            i(1),
            d(2, rec_ls, {}),
            t({ "", "\\end{itemize}" }),
        }),


        -- --- lemon moll_snippets
        -- ls.parser.parse_snippet({trig = ";"}, "\\$$1\\$$0"),
        -- s({trig = "(s*)sec", wordTrig = true, regTrig = true}, {
        --     f(function(args) return {"\\"..string.rep("sub", string.len(args[1].captures[1]))} end, {}),
        --     t({"section{"}), i(1), t({"}", ""}), i(0)
        -- }),
        -- ls.parser.parse_snippet({trig = "beg", wordTrig = true}, "\\begin{$1}\n\t$2\n\\end{$1}"),
        -- ls.parser.parse_snippet({trig = "beq", wordTrig = true}, "\\begin{equation*}\n\t$1\n\\end{equation*}"),
        -- ls.parser.parse_snippet({trig = "bal", wordTrig = true}, "\\begin{aligned}\n\t$1\n\\end{aligned}"),
        -- ls.parser.parse_snippet({trig = "ab", wordTrig = true}, "\\langle $1 \\rangle"),
        -- ls.parser.parse_snippet({trig = "lra", wordTrig = true}, "\\leftrightarrow"),
        -- ls.parser.parse_snippet({trig = "Lra", wordTrig = true}, "\\Leftrightarrow"),
        -- ls.parser.parse_snippet({trig = "fr", wordTrig = true}, "\\frac{$1}{$2}"),
        -- ls.parser.parse_snippet({trig = "tr", wordTrig = true}, "\\item $1"),
        -- ls.parser.parse_snippet({trig = "abs", wordTrig = true}, "\\|$1\\|"),
        -- s("ls", {
        --     t({"\\begin{itemize}",
        --         "\t\\item "}), i(1), d(2, rec_ls, {}),
        --     t({"", "\\end{itemize}"}), i(0)
        -- })
    }
}
