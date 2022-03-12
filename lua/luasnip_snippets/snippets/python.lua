local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node

local function generic_pdoc(ilevel, args)
    local nodes = { t({ "'''", string.rep('\t', ilevel) }) }
    nodes[#nodes + 1] = i(1, 'Small Description.')
    nodes[#nodes + 1] = t({ '', '', string.rep('\t', ilevel) })
    nodes[#nodes + 1] = i(2, 'Long Description')
    nodes[#nodes + 1] = t({ '', '', string.rep('\t', ilevel) .. 'Args:' })

    local a = vim.tbl_map(function(item)
        local trimed = vim.trim(item)
        return trimed
    end, vim.split(
            args[1][1],
            ',',
            true
        ))

    if args[1][1] == '' then
        a = {}
    end

    for idx, v in pairs(a) do
        nodes[#nodes + 1] = t({ '', string.rep('\t', ilevel + 1) .. v .. ': ' })
        nodes[#nodes + 1] = i(idx + 2, 'Description For ' .. v)
    end

    return nodes, #a
end

local function pyfdoc(args, ostate)
    local nodes, a = generic_pdoc(1, args)
    nodes[#nodes + 1] = c(a + 2 + 1, { t(''), t({ '', '', '\tReturns:' }) })
    nodes[#nodes + 1] = i(a + 2 + 2)
    nodes[#nodes + 1] = c(a + 2 + 3, { t(''), t({ '', '', '\tRaises:' }) })
    nodes[#nodes + 1] = i(a + 2 + 4)
    nodes[#nodes + 1] = t({ '', "\t'''", '\t' })
    local snip = sn(nil, nodes)
    snip.old_state = ostate or {}
    return snip
end

local function pycdoc(args, ostate)
    local nodes, _ = generic_pdoc(2, args)
    nodes[#nodes + 1] = t({ '', "\t\t'''", '' })
    local snip = sn(nil, nodes)
    snip.old_state = ostate or {}
    return snip
end

return {
    python = {
        s({ trig = 'cls', dscr = 'Documented Class Structure' }, {
            t('class '),
            i(1, { 'CLASS' }),
            t('('),
            i(2, { '' }),
            t({ '):', '\t' }),
            t({ 'def init(self,' }),
            i(3),
            t({ '):', '\t\t' }),
            d(4, pycdoc, { 3 }, { user_args = 2 }),
            f(function(args)
                if not args[1][1] or args[1][1] == '' then
                    return { '' }
                end
                local a = vim.tbl_map(function(item)
                    local trimed = vim.trim(item)
                    return '\t\tself.' .. trimed .. ' = ' .. trimed
                end, vim.split(
                        args[1][1],
                        ',',
                        true
                    ))
                return a
            end, {
                    3,
                }),
            i(0),
        }),
        s({ trig = 'fn', dscr = 'Documented Function Structure' }, {
            t('def '),
            i(1, { 'function' }),
            t('('),
            i(2),
            t({ '):', '\t' }),
            d(3, pyfdoc, { 2 }, { user_args = 1 }),
        }),
    }
}

