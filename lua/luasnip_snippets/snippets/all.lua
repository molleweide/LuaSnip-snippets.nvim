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

local utils = require("luasnip_snippets.utils")

-- FUNCTIONS START --------------------------------------------------------

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end


-- FUNCTIONS END ---------------------------------------------------------------

return {
    all = {
        -- Use a dynamic_node to interpolate the output of a
	    -- function (see utils.date_input above) into the initial
	    -- value of an insert_node.
	    s("novel", {
	        t("It was a dark and stormy night on "),
	        d(1, utils.date_input, {}, { user_args = "%A, %B %d of %Y" }),
	        t(" and the clocks were striking thirteen."),
	    }),

	    utils.pair("(", ")", neg, char_count_same),
	    utils.pair("{", "}", neg, char_count_same),
	    utils.pair("[", "]", neg, char_count_same),
	    utils.pair("<", ">", neg, char_count_same),
	    utils.pair("'", "'", neg, even_count),
	    utils.pair('"', '"', neg, even_count),
	    utils.pair("`", "`", neg, even_count),

	    -- Use a function to execute any shell command and print its text.
	    s("bash", f(utils.bash, {}, "ls")),

        -- current date
	    s({ trig = "ymd", name = "Current date", dscr = "Insert the current date" }, {
	        p(os.date, "%Y-%m-%d"),
	    }),

	    s({trig="{,", wordTrig=false, hidden=true}, { t({"{","\t"}), i(1), t({"", "}"}) }),

	    ls.parser.parse_snippet({trig = "tr"}, "if ${1:[[ ${2:word} -eq ${3:word2} ]]}; then\n\t$4\nfi"),
    }
}
