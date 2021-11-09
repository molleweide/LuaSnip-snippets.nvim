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



-- { "/Users/hjalmarjakobsson/.config/nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/cheovim/start/cheovim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/aerial.nvim/lua", "
-- /Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/Catppuccino.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/dashboard-nvim/lua", "/Users/hjalmarjakobsson/.local/share
-- /nvim/site/pack/packer/start/diffview.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/doom-themes.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/firenvim
-- /lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/galaxyline.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/github-nvim-theme/lua", "/Users/hjalmarjakobsson/.l
-- ocal/share/nvim/site/pack/packer/start/nabla.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/nvim-bqf/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/nvim-lspc
-- onfig/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/nvim-lspmanager/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/nvim-mapper/lua", "/Users/hjalmarjakobsson/.lo
-- cal/share/nvim/site/pack/packer/start/nvim-transparent/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/persistence.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/st
-- art/quickmath.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/registers.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/sqlite.lua/lua", "/Users/hjalmarja
-- kobsson/.local/share/nvim/site/pack/packer/start/telescope-bibtex.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-bookmarks.nvim/lua", "/Users/hjalmarjakobsson/.local/share/
-- nvim/site/pack/packer/start/telescope-cheat.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-dict.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start
-- /telescope-emoji.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-ghq.nvim/lua
-- ", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-heading.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-luasnip.nvim/lua", "/Users/hjalmarjako
-- bsson/.local/share/nvim/site/pack/packer/start/telescope-node-modules.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-packer.nvim/lua", "/Users/hjalmarjakobsson/.local/share
-- /nvim/site/pack/packer/start/telescope-project.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-repo.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/st
-- art/telescope-tele-tabby.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-test.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/telescope-z.nvim/l
-- ua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/venn.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/vim-be-good/lua", "/Users/hjalmarjakobsson/.local/share/nvi
-- m/site/pack/packer/start/vim-moonfly-colors/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/start/vim-nightfly-guicolors/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/ani
-- seed/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/moll-snippets.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/LuaSnip/lua", "/Users/hjalmarjakobsson/.local/sh
-- are/nvim/site/pack/packer/opt/nvim-autopairs/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/which-key.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/nvim-ts-cont
-- ext-commentstring/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/nvim-tree-docs/lua", "/Users/hjalmarja
-- kobsson/.local/share/nvim/site/pack/packer/opt/neorg/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/tod
-- o-comments.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim/lua", "/Users/h
-- jalmarjakobsson/.local/share/nvim/site/pack/packer/opt/cmd-parser.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/range-highlight.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/s
-- ite/pack/packer/opt/gitsigns.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/TrueZen.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/kommentary/lua", "/Users/
-- hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/DAPInstall.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/nvim-dap-ui/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack
-- /packer/opt/nvim-dap/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/bufferline.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/rest.nvim/lua", "/Users/hjalmarjako
-- bsson/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/plenary.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/
-- opt/lua-dev.nvim/lua", "/Users/hjalmarjakobsson/.local/share/nvim/site/pack/packer/opt/packer.nvim/lua", "/usr/local/Cellar/neovim/HEAD-2481b18_1/share/nvim/runtime/lua", "/Users/hjalmarjakobsson/code/plugins/nvi
-- m/lookup.nvim/lua" }

function print_fnames()
    print("print_fnames")

    local nvim_snippets = vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)
    local moll_snippets = vim.api.nvim_get_runtime_file("lua/moll_snippets/lib/*.lua", true)

    -- print(i(vim.api.nvim_get_runtime_file("lua/moll_snippets/lib/*.lua", true)))

    for _, fname in ipairs(moll_snippets) do
        -- print("arstarstarstarstrst")
        -- local str_split = str_2_table(fname, "-")
        print( get_file_name( fname ) )
        -- print( _ )
        -- print(str_split[1])
        -- vim.inspect(str_split)
    end

end

function M.load_snippets()
    -- print("::: moll snip :::")
    print_fnames()
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


