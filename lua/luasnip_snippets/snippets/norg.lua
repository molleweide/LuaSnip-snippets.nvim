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

-- link to spec
-- https://github.com/nvim-neorg/neorg/blob/main/docs/NFF-0.1-spec.md#tags

-- TODO: add snippets for these.
--     - [ ] Add more literate programming features
--      ~> [another cool plugin](https://github.com/danymat/neogen)


return {
    norg = {
        -- make this more modular so that you can modify the @{...} ...., and then the code...
        -- rename this to "neorg tags"
        s("norg code", { -- neorg tag
            t({ "@code", "" }),
            -- insert code, text, " ", insert lang
            i(1, "code goes here.."),
            t({ "", "@end"}),
        }),

        s("neorg checkbox", {
            t("- [ ] "), i(1, "todo.."),
        }),

        -------------------------
        ---       links       ---
        -------------------------

        s("neorg link curly", {
            t("{"), i(1, "name"), t("}["),  i(2, "link"), t("]"),
        }),
        s("neorg link paren", {
            t("("), i(1, "name"), t(")["),  i(2, "link"), t("]"),
        }),
        s("neorg link square", {
            t("["), i(1, "name"), t("]["),  i(2, "link"), t("]"),
        }),
        --


        -- TODO: GTD
        -- TODO: date
        -- yyyy-mm-dd


        -- TODO: gtd project
        -- @code norg
        --     #contexts §context_name§ §context_name§ ...
        --     #time.start §date§
        --     #time.due §date§
        --     * §Project name§
        --     - [ ] §Task description§
        -- @end
        s("neorg project starter", {
            t("#context $"), i(1, "context name"), t({ "$", "" }),
            t("#time.start $"), i(2, "date"), t({ "$", "" }),
            t("#time.due $"), i(3, "date"), t({ "$", "" }),
            t("* $"), i(4, "project name"), t({ "$", "" }),
            t("- [ ] $"), i(5, "task description"), t("$"),
        }),

        -- @code norg
        -- | §Area Of Focus name§
        -- marker body
        -- | _
        -- @end
        s("neorg focus area", {
            t("| $"), i(1, "focus_area_name"), t({ "$", "" }),
            i(1, "marker body"),
            t({ "", "| _"}),
        }),


        -- TODO: table snippets
      -- @table
      -- Column 1 | Column 2
      -- -
      -- This is in a new row | which got separated by a horizontal line
      -- And check this out: I can span the columns!
      -- @end

        -- TODO: media images / video
      -- @image png svg jpeg jfif exif
      -- <base64-encoded image data>
      -- @end

      -- @embed image
      -- https://github.com/vhyrro/neorg/blob/main/res/neorg.svg
      -- @end

        -- TODO: math

      -- @math
      -- f(x) = y
      -- @end


    }
}
