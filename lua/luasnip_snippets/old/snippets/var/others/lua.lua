local ls = require('luasnip')
local l = require('luasnip.extras').lambda
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = 'req', dscr = 'Require Module' }, {
    t({ 'local ' }),
    l(l._1:match('([^.()]+)[()]*$'), 1),
    t({ " = require('" }),
    i(1),
    t({ "')" }),
    i(0),
  }),
}

