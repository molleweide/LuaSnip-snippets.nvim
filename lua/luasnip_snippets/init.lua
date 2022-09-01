local ls = require("luasnip")

local M = {}

-- TODO: V2
--
--
-- need to make filepaths into lua module paths before we insert them into the main table.
--
--
-- 1. copy path utils doom system and paste below
-- 2. put all paths path segments in table below.
-- 3. print everything.
-- 4. read luasnip manual again.
--
-- use path table to make path logic a little bit nicer looking

-- USER SNIPPETS DIR
--
-- A. snippets in root dir can have multiple file extensions.
-- B. snippets in ft folders only return a table return {}
--
--

local PATHS = {
	sep_lua = ".",
	sep_sys = "/", -- how is this done in doom?
	lua_all = "*.lua",
	lua_ext = ".lua",
	lua_pre = "lua/",
}

-- TODO: setup()
local settings = {
	defaults = {
		snippets_path_user = "lua/snippets", -- rename: default
		sys_path = "lua/snippets",
		lua_path = "snippets",
	},
	snippets_path_internal = "lua/luasnip_snippets/snippets",
	snippets_mod_path_internal = "luasnip_snippets.snippets",
}

-- local snippets_path_user = "lua/snippets/"
-- local snippets_path_internal = "lua/luasnip_snippets/snippets/"
-- -- in-lua path prefixes
-- local nvim_snippets_modules = "snippets."
-- local snippets_mod_path_internal = "luasnip_snippets.snippets."

-- TODO: mv these lua utils to utils/init.lua && rename the current util file -> `util/snippets.lua`
-- ??
function str_2_table(s, delimiter)
	result = {}
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end
-- ??
function get_file_name(file)
	return file:match("^.+/(.+)$")
end

-- FIX: USE VIM TBL MERGE
--
-- understand what is going on here.
--
-- !!!! what happens if I move the user snippets dir under `lua/`???
--
-- 1. can I tbl merge entries into the LuaSnip main table?
-- 2. can one merge each snippet here.
function insert_snippets_into_table(t, modules_str, paths_table)
	for _, snip_fpath in ipairs(paths_table) do
		local snip_mname = get_file_name(snip_fpath):sub(1, -5)

		local sm = require(modules_str .. snip_mname)

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

local function get_snippets_files_from_dir(path)
	-- local nvim_snippets = vim.api.nvim_get_runtime_file(snippets_path_user .. "*.lua", true)
	-- local luasnip_snippets = vim.api.nvim_get_runtime_file(settings.snippets_path_internal .. "*.lua", true)
	-- return snippets
end

local function prepare_large_snippets_table() end

local function merge_snippets_into_luasnip()
	-- load snippets here...
	--
	-- Try this one here and see if it works:
	--     ls.add_snippets(filetype, snippets)
	--
	--
	-- What other possible loading mechanisms can we try here?
	--
	--
	--
end

function M.setup(opts)
	local t_snippet_modules = {}
	local t = {}

	--
	-- 1: GET USER SNIPPET FILE PATHS
	--

	if opts.paths then
		-- loop over user paths and collect snippet filepaths
		for _, user_path in ipairs(opts.paths) do
			local up = PATHS.lua_pre .. user_path .. PATHS.sep_sys .. PATHS.lua_all
			local t_paths = vim.api.nvim_get_runtime_file(up, true)
			for _, snippets_file_path in ipairs(t_paths) do
				local mp = user_path .. PATHS.sep_lua .. get_file_name(snippets_file_path):sub(1, -5)
				table.insert(t_snippet_modules, mp)
			end
		end
	else
		-- default
		local default_paths = vim.api.nvim_get_runtime_file(
			settings.defaults.sys_path .. PATHS.sep_sys .. PATHS.lua_all,
			true
		)
		for _, dp in ipairs(default_paths) do
			local mp = settings.defaults.lua_path .. PATHS.sep_lua .. get_file_name(dp):sub(1, -5)
			table.insert(t_snippet_modules, mp)
		end
	end

	--
	-- 2: GET INTERNAL SNIPPETS
	--

	local luasnip_snippets_paths = vim.api.nvim_get_runtime_file(
		settings.snippets_path_internal .. PATHS.sep_sys .. PATHS.lua_all,
		true
	)
	for _, path in ipairs(luasnip_snippets_paths) do
		local mp = settings.snippets_mod_path_internal .. PATHS.sep_lua .. get_file_name(path):sub(1, -5)
		table.insert(t_snippet_modules, mp)
	end

	--
	-- 3: COMPILE ALL SNIPETS INTO ONE LARGE SNIPPETS TABLE BY FILETYPE
	--

	-- extend_luasnip_with_snippets()
	-- t = insert_snippets_into_table(t, nvim_snippets_modules, nvim_snippets)
	-- t = insert_snippets_into_table(t, snippets_mod_path_internal, luasnip_snippets)

	-- for _, mod_path in ipairs(t_snippet_modules) do
	-- 	local sm = require(mod_path)
	-- 	for ft, snips in pairs(sm) do
	-- 		if t[ft] == nil then
	-- 			t[ft] = snips
	-- 		else
	-- 			for _, s in pairs(snips) do
	-- 				table.insert(t[ft], s)
	-- 			end
	-- 		end
	-- 	end
	-- end

	------------
	-- print("s table >>>", vim.inspect(t))
	------------

	--
	-- 4: LOAD SNIPPETS INTO LUASNIP.
	--

	-- for ft, ft_snippets in pairs(t_all_snippets) do
	-- end

	-- return t
end

return M
