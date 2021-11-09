-- local Path = require 'plenary.path'
local ls = require("luasnip")
local i = vim.inspect
-- local s = ls.snippet
-- local t = ls.text_node

-- local scan = require 'plenary.scandir'

-- local abs_path_script = debug.getinfo(1,"S").source:sub(2)
-- local scrit_dir_abs = debug.getinfo(1,"S").source:sub(2, -10) .. "/lib"
-- local script_dir = ...


-- 1. create config function
-- 2. add load_snippets function
-- 3. rm everything from doom.
-- 4. if this works
--      create new git alias >> auto add notes, and snippets.

function str_2_table(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- local lib_filenames = scandir(scrit_dir_abs)
-- -- print(vim.inspect(lib_filenames))
-- for _, fname in ipairs(lib_filenames) do
--     local str_split = str_2_table(fname, "-")
--     -- print(fname)
--     -- print(str_split[1])
--     -- vim.inspect(str_split)
-- end

function get_file_name(file)
    return file:match("^.+/(.+)$")
end

-- print(vim.inspect(dsnip))

-- print(vim.inspect( scan.scan_dir( ..., { hidden = true, depth = 2 }) ))

-- print("...2 -> `" .. (...):match("(.-)[^%.]+$") .. "`")

-- local folderOfThisFile = (...):match("(.-)[^%.]+$")
-- print(debug.getinfo(1,"S").source:sub(2))

-- print( path._fs_filename )
-- print("self:absolute(): " .. self:absolute())

local M = {}

-- -- inject table of snippets into filetype
-- -- @filetype    string
-- -- @snippets    string
-- local add_snippets = function( filetype, snippets )

--     if snippets == nil then snippets = filetype end

--     local st = require("snippets.lib." .. snippets)

--     for _,v in ipairs(st) do

--         if M[filetype] ~= nil then
--             -- local extr = filetype:gsub("snippets-", "")
--             -- print("extr: " .. extr)
--             table.insert(M[filetype], v)
--         else
--             M[filetype] = {}
--             table.insert(M[filetype], v)
--         end
--     end
-- end



-- add_snippets( "all", "_helper_snippets")
-- add_snippets( "all", "all")
-- add_snippets( "all", "help")
-- add_snippets( "all", "test")
-- add_snippets( "all", "comment_headers")
-- add_snippets( "all", "git")
-- add_snippets( "all", "doom")
-- add_snippets( "c" )
-- add_snippets( "snippets-norg" )
-- add_snippets( "lua")
-- add_snippets( "java")
-- add_snippets( "tex")
-- add_snippets( "python")

-- print(i(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)))
-- print(i(vim.api.nvim_get_runtime_file("moll_snippets/lib/*.lua", true)))


function M.load_snippets()
    local nvim_snippets = vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)
    local moll_snippets = vim.api.nvim_get_runtime_file("lua/moll_snippets/lib/*.lua", true)

    -- print(i(vim.api.nvim_get_runtime_file("lua/moll_snippets/lib/*.lua", true)))

    for _, fname in ipairs(moll_snippets) do
        print( get_file_name( fname ) )
        local str_split = str_2_table(fname, "-")
        -- print( _ )
        -- print(str_split[1])
        -- vim.inspect(str_split)
    end
end

function M.test()
    print("test")
end


print("print in moll snippets!")

return M

-- -- print(Path("."))
-- -- print("script_dir -> `" .. script_dir .. "`")
-- -- print("abs path: " .. abs_path_script)
-- -- Lua implementation of PHP scandir function
-- function scandir(directory)
--     local i, t, popen = 0, {}, io.popen
--     local pfile = popen('ls "'..directory..'"')
--     for filename in pfile:lines() do
--         i = i + 1
--         t[i] = filename
--     end
--     pfile:close()
--     return t
-- end


