local load = require("luasnip").add_snippets

local M = {}

--  - copy path utils doom system and paste below
--  - read luasnip manual again.

-- USER SNIPPETS DIR ???
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

local settings = {
	defaults = {
		snippets_path_user = "lua/snippets", -- rename: default
		sys_path = "lua/snippets",
		lua_path = "snippets",
	},
	snippets_path_internal = "lua/luasnip_snippets/snippets",
	snippets_mod_path_internal = "luasnip_snippets.snippets",
}

-- -- ??
-- function str_2_table(s, delimiter)
-- 	result = {}
-- 	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
-- 		table.insert(result, match)
-- 	end
-- 	return result
-- end

function get_file_name(file)
	return file:match("^.+/(.+)$")
end

function M.setup(opts)
	local t_snippet_modules = {}
	local t = {}

	-- GET USER SNIPPET FILE PATHS
	if opts.paths then
		-- loop over user paths and collect snippet filepaths
		for _, user_path in ipairs(opts.paths) do
			local up = PATHS.lua_pre .. user_path .. PATHS.sep_sys .. PATHS.lua_all
			local t_paths = vim.api.nvim_get_runtime_file(up, true)
			for _, snippets_file_path in ipairs(t_paths) do
				local mp = user_path:gsub(PATHS.sep_sys, ".") .. PATHS.sep_lua .. get_file_name(snippets_file_path):sub(1, -5)
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

	print(vim.inspect(t_snippet_modules))

	-- -- GET INTERNAL SNIPPETS
	-- local luasnip_snippets_paths = vim.api.nvim_get_runtime_file(
	-- 	settings.snippets_path_internal .. PATHS.sep_sys .. PATHS.lua_all,
	-- 	true
	-- )
	-- for _, path in ipairs(luasnip_snippets_paths) do
	-- 	local mp = settings.snippets_mod_path_internal .. PATHS.sep_lua .. get_file_name(path):sub(1, -5)
	-- 	table.insert(t_snippet_modules, mp)
	-- end

	-- LOAD SNIPPETS
	for _, mod_path in ipairs(t_snippet_modules) do
		local sm = require(mod_path)
		for ft, snips in pairs(sm) do
			load("ft", snips)
			-- 	if t[ft] == nil then
			-- 		t[ft] = snips
			-- 	else
			-- 		for _, s in pairs(snips) do
			-- 			table.insert(t[ft], s)
			-- 		end
		end
	end
end

return M
