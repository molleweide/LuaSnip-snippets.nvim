local M = {}

local nvim_snippets_path = "lua/snippets/"
local luasnip_snippets_path = "lua/luasnip_snippets/snippets/"
local nvim_snippets_modules = "snippets."
local luasnip_snippets_modules = "luasnip_snippets.snippets."

function str_2_table(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function get_file_name(file)
    return file:match("^.+/(.+)$")
end

function insert_snippets_into_table(t, modules_str, paths_table)

    for _, snip_fpath in ipairs(paths_table) do

        local snip_mname = get_file_name( snip_fpath ):sub(1,-5)

        local sm = require( modules_str .. snip_mname )

        for ft, snips in pairs(sm) do
            if t[ft] == nil then
                t[ft] = snips
            else
                for _, s in pairs(snips) do
                    table.insert(t[ft], s)
                end
            end
        end

    end
    return t
end

function M.load_snippets()

    print("load luasnip_snippets")

    local t = {}

    local nvim_snippets = vim.api.nvim_get_runtime_file( nvim_snippets_path .. "*.lua", true)
    local luasnip_snippets = vim.api.nvim_get_runtime_file( luasnip_snippets_path .. "*.lua", true)

    t = insert_snippets_into_table(t, nvim_snippets_modules, nvim_snippets)
    t = insert_snippets_into_table(t, luasnip_snippets_modules, luasnip_snippets)

    return t
end

return M
