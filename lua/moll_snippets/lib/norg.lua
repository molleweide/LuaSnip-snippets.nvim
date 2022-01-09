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

local utils = require("moll_snippets.utils")

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



      -- @code norg
      -- | §Area Of Focus name§
      -- marker end
      -- | _
      -- @end


      -- Below is an example with AOF's:

      -- @code norg
      -- | This is an AOF

      -- * This is a project
      -- - [ ] This is a task inside a project

      -- * This is another project
      -- - [ ] This is a task inside the other project

      -- * This is a very large project
      --  ** This is a heading for the project
      --     - [ ] This is a task
      --  ** This is another heading for the project
      --     - [ ] This is a task

      -- | _

      -- This is not in an AOF
      -- @end
        --

    -- TODO: quotes / comments
        -- would it be possible to implement this with lua snippet dynamic
        -- snippets?

    -- TODO: table snippets

    -- TODO: media images / video

    -- TODO: math



    }
}
