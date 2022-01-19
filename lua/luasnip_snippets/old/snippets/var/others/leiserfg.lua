local ls = require "luasnip"
local parser = require("luasnip.util.parser").parser
local l = require("luasnip.extras").l

-- local _1 = require "luasnip.util.lambda"._1
local s = ls.s
local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
local c = ls.c
local d = ls.d
math.randomseed(os.time())
local function uuid()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local out
    local function subs(c)
        local v = (((c == "x") and random(0, 15)) or random(8, 11))
        return string.format("%x", v)
    end
    out = template:gsub("[xy]", subs)
    return out
end
local function copy(args, a1, a2)
    return args[1]
end
local LOREM_IPSUM =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
local function sf(trig, body, regTrig)
    return s({ regTrig = regTrig, trig = trig, wordTrig = true }, { f(body, {}), i(0) })
end
local function replace_each(replacer)
    local function wrapper(args)
        local len = #(args[1])[1]
        return { replacer:rep(len) }
    end
    return wrapper
end
local function emmet(arg1)
    local content = (arg1)[1][1]
    return sn(nil, { t { "asdf", content, "asdf" } })
end
local function _1_()
    return { os.date "%Y-%m-%d" }
end
local function _2_()
    return { uuid() }
end
local function _3_(args)
    local amount = tonumber(args[1].captures[1])
    if amount == nil then
        return { LOREM_IPSUM }
    else
        return { LOREM_IPSUM:sub(1, (amount + 1)) }
    end
end
ls.snippets = {
    all = {
        sf("date", _1_),
        sf("uuid", _2_),
        sf("lorem(%d*)", _3_, true),

        s({ trig = "tt", wordTrig = true }, {
            t { "╔" },
            f(function()
                return "0"
            end, {}),
            t { "1", "2" },
            i(0),
        }),

        s({ trig = "bbox" }, {
            t { "╔" },
            f(replace_each "═", { 1 }),
            t { "╗", "║" },
            i(1, { "content" }),
            t { "║", "╚" },
            f(replace_each "═", { 1 }),
            t { "╝" },
            i(0),
        }),
        s({ trig = "sbox", wordTrig = true }, {
            t { "*" },
            f(replace_each "-", { 1 }),
            t { "*", "|" },
            i(1, { "content" }),
            t { "|", "*" },
            f(replace_each "-", { 1 }),
            t { "*" },
            i(0),
        }),
        ls.parser.parse_snippet(
            { trig = "foo" },
            [[
            ${$TM_SELECTED_TEXT} --  TM_SELECTED_TEXT The currently selected text or the empty string
            ${$TM_CURRENT_LINE} --  TM_CURRENT_LINE The contents of the current line
            ${$TM_CURRENT_WORD} --  TM_CURRENT_WORD The contents of the word under cursor or the empty string
            ${$TM_LINE_INDEX} --  TM_LINE_INDEX The zero-index based line number
            ${$TM_LINE_NUMBER} --  TM_LINE_NUMBER The one-index based line number
            ${$TM_FILENAME} --  TM_FILENAME The filename of the current document
            ${$TM_FILENAME_BASE} --  TM_FILENAME_BASE The filename of the current document without its extensions
            ${$TM_DIRECTORY} --  TM_DIRECTORY The directory of the current document
            ${$TM_FILEPATH} --  TM_FILEPATH The full file path of the current document
            ${$RELATIVE_FILEPATH} --  RELATIVE_FILEPATH The relative (to the opened workspace or folder) file path of the current document
            ${$CLIPBOARD} --  CLIPBOARD The contents of your clipboard
            ${$WORKSPACE_NAME} --  WORKSPACE_NAME The name of the opened workspace or folder
            ${$WORKSPACE_FOLDER} --  WORKSPACE_FOLDER The path of the opened workspace or folder
            ${$CURRENT_YEAR} --  CURRENT_YEAR The current year
            ${$CURRENT_YEAR_SHORT} --  CURRENT_YEAR_SHORT The current year's last two digits
            ${$CURRENT_MONTH} --  CURRENT_MONTH The month as two digits (example '02')
            ${$CURRENT_MONTH_NAME} --  CURRENT_MONTH_NAME The full name of the month (example 'July')
            ${$CURRENT_MONTH_NAME_SHORT} --  CURRENT_MONTH_NAME_SHORT The short name of the month (example 'Jul')
            ${$CURRENT_DATE} --  CURRENT_DATE The day of the month
            ${$CURRENT_DAY_NAME} --  CURRENT_DAY_NAME The name of day (example 'Monday')
            ${$CURRENT_DAY_NAME_SHORT} --  CURRENT_DAY_NAME_SHORT The short name of the day (example 'Mon')
            ${$CURRENT_HOUR} --  CURRENT_HOUR The current hour in 24-hour clock format
            ${$CURRENT_MINUTE} --  CURRENT_MINUTE The current minute
            ${$CURRENT_SECOND} --  CURRENT_SECOND The current second
            ${$CURRENT_SECONDS_UNIX} --  CURRENT_SECONDS_UNIX The number of seconds since the Unix epoch
            ${$RANDOM} --  RANDOM 6 random Base-10 digits
            ${$RANDOM_HEX} --  RANDOM_HEX 6 random Base-16 digits
            ${$UUID} --  UUID A Version 4 UUID
            ${$BLOCK_COMMENT_START} --  BLOCK_COMMENT_START Example output: in PHP /* or in HTML <!--
            ${$BLOCK_COMMENT_END} --  BLOCK_COMMENT_END Example output: in PHP */ or in HTML -->
            ${$LINE_COMMENT} --  LINE_COMMENT Example output: in PHP //
            ]]
        ),
        s({ trig = "csv", wordTrig = true }, {
            i(1, { "content" }),
            t { "", "separator", "" },
            i(2, { "|" }),
            t { "", ">>", "" },
            l(l._1:gsub(",", l._2) or "adsf", { 1, 2 }),
        }),
    },
    direnv = {
        s({ trig = "lay", wordTrig = true }, { t { "layout " }, i(1, { "python" }), i(0) }),
    },
}
