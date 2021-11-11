local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local l = require("luasnip.extras").lambda

return {

    all = {
        s("div 1", {
            t({
                "----------------------",
                "---     " }), i(1, "title"), t({ "     ---",
                "-----[[------------]]-----", }),
        }),

        -- basic expanding comment header
        -- currently only working for lua
        s("header 1", {
            t("----------"), l(l._1:gsub(".", "-"), 1), t({ "----------", "" }),
            t("---       "), i(1, "header title"),      t({ "       ---", ""}),
            t("----------"), l(l._1:gsub(".", "-"), 1), t({ "----------", ""}),
        }),

        -- huge, use figlet to create mega huge headings
        -- 1. write text
        -- 2. on extit snippet
        -- 3. pass to figlet
        -- 4. str_2_table
        -- 5. longest string
        -- 6. frame based on length
    }
}

