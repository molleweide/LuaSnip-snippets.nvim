local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node

local function rec_ls()
    return sn(nil, {
        c(1, {
            t(''),
            sn(nil, {
                t({ '', '\t\\item ' }),
                i(1),
                d(2, rec_ls, {}),
            }),
        }),
    })
end

return {
    s({ trig = 'beg', dscr = 'Add Environment' }, {
        t('\\begin{'),
        f(function(args)
            return args[1][1]
        end, { 1 }),
        t({ '}', '\t' }),
        i(0),
        t({ '', '\\end{' }),
        i(1),
        t('}'),
    }),
    s({ trig = 'fig', dscr = 'Add Figure' }, {
        t({ '\\begin{figure}[!h]', '\t\\centering', '\t\\includegraphics[width=' }),
        i(1),
        t({ ']{' }),
        i(2, 'path'),
        t({ '}', '\t\\caption{' }),
        i(3, 'caption'),
        t({ '}', '\\end{figure}' }),
    }),
    s({ trig = 'enum', dscr = 'Add Enumerate' }, {
        t({ '\\begin{enumerate}', '\t\\item' }),
        i(1),
        d(2, rec_ls, {}),
        t({ '', '\\end{enumerate}' }),
        i(0),
    }),
    s({ trig = 'ls', dscr = 'Add Enumerate' }, {
        t({ '\\begin{itemize}', '\t\\item' }),
        i(1),
        d(2, rec_ls, {}),
        t({ '', '\\end{itemize}' }),
        i(0),
    }),
}

