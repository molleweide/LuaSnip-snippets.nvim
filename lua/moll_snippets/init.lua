local M = {}

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

function insert_snippets_into_table(t, paths_table)
    local t = t
    for _, snip_fpath in ipairs(paths_table) do

        local snip_fname = get_file_name( snip_fpath )
        local snip_mname = snip_fname:sub(1,-5)
        local str_split = str_2_table(snip_mname, "-")

        local ft = str_split[2]:match("%w+")
        local sm = require("moll_snippets.lib." .. snip_mname)

        print(snip_mname, ft)

        t[ft] = sm
        -- print(t, ft)
        -- table.insert(t[ft], sm)
    end
    return t
end

function M.load_snippets()

    local t = {}

    local nvim_snippets = vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)
    local moll_snippets = vim.api.nvim_get_runtime_file("lua/moll_snippets/lib/*.lua", true)

    t = insert_snippets_into_table(t, nvim_snippets)
    t = insert_snippets_into_table(t, moll_snippets)

    return t
end

return M

