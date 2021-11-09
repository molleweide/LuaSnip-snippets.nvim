local Path = require 'plenary.path'
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local scan = require 'plenary.scandir'

local abs_path_script = debug.getinfo(1,"S").source:sub(2)
local scrit_dir_abs = debug.getinfo(1,"S").source:sub(2, -10) .. "/lib"
local script_dir = ...

-- TODO: 1. make this work with current setup
-- scandir...

-- TODO: 2. use rtp instead
-- user snippets: /lua/snippets
-- plug snippets: /<plugin_name>/lua/lib/**

-- ``` REPLY FROM DISCOURSE
-- I would make the user put the files in a directory on the runtime and use
-- vim.api.nvim_get_runtime_file with the pattern mysnippet_plugin/*.lua that
-- would find all the files, then I would do a little regex to generete the
-- names needed to load them using the built in require() which will do the
-- cache for you and will only see improvements since it’s being worked on (in
-- the future what impatient.nvim does will be implemented in core).
-- ```

-- print(Path("."))

-- print("script_dir -> `" .. script_dir .. "`")
-- print("abs path: " .. abs_path_script)

-- Lua implementation of PHP scandir function

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function str_2_table(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
local lib_filenames = scandir(scrit_dir_abs)
-- print(vim.inspect(lib_filenames))
for _, fname in ipairs(lib_filenames) do
    local str_split = str_2_table(fname, "-")
    -- print(fname)
    -- print(str_split[1])
    -- vim.inspect(str_split)
end

function get_file_name(file)
      return file:match("^.+/(.+)$")
end

-- TODO: get config and plugin filenames
local doom_snippets = vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)

-- for _, fname in ipairs(doom_snippets) do
--     -- local str_split = str_2_table(fname, "-")
--     print(get_file_name( fname ))
--     -- print(str_split[1])
--     -- vim.inspect(str_split)
-- end
-- -- print(vim.inspect(dsnip))

-- print(vim.inspect( scan.scan_dir( ..., { hidden = true, depth = 2 }) ))

-- print("...2 -> `" .. (...):match("(.-)[^%.]+$") .. "`")

-- local folderOfThisFile = (...):match("(.-)[^%.]+$")
-- print(debug.getinfo(1,"S").source:sub(2))

-- print( path._fs_filename )
-- print("self:absolute(): " .. self:absolute())

local M = {}

-- FIX: create loop that looks at file names in snippets lib
--      and extracts sting parts.
--
--      naming convention
--      snippets-filetype-descriptor.lua
--
--      TODO: slit file name on delimiter `-`

-- inject table of snippets into filetype
-- @filetype    string
-- @snippets    string
local add_snippets = function( filetype, snippets )

    if snippets == nil then snippets = filetype end

    local st = require("snippets.lib." .. snippets)

    for _,v in ipairs(st) do

        if M[filetype] ~= nil then
            -- local extr = filetype:gsub("snippets-", "")
            -- print("extr: " .. extr)
            table.insert(M[filetype], v)
        else
            M[filetype] = {}
            table.insert(M[filetype], v)
        end
    end
end

add_snippets( "all", "_helper_snippets")
add_snippets( "all", "all")
add_snippets( "all", "help")
add_snippets( "all", "test")
add_snippets( "all", "comment_headers")
add_snippets( "all", "git")
add_snippets( "all", "doom")
add_snippets( "c" )
add_snippets( "snippets-norg" )
add_snippets( "lua")
add_snippets( "java")
add_snippets( "tex")
add_snippets( "python")

-- -- example
-- ls.autosnippets = {
-- 	all = {
-- 		s("autotrigger", {
-- 			t("autosnippet"),
-- 		}),
-- 	},
-- }

return M
