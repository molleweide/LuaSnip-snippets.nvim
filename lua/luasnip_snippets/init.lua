local load = require("luasnip").add_snippets

local M = {}

-- TODO:
--
--      - REFACTOR: paths so that the for loops get a little bit more cleaned
--                  up
--
--              get all snippet modules()
--
--
--      - READ: telescope-luasnip picker code
--              -> integrate with `luasnip_snippets` crud manager
--
--      - HOW DO I GET ALL FILETYPES IN A LIST FOR FUZZY???
--
--        i. supply list in configs
--        ii. nvim api get filetypes list?
--
--      - PICKER TYPES
--
--        2 pickers -> filetype AND snippet treesitter symbols
--
--      - SNIPPET PICKER ACTIONS
--
--        1. select filetype
--        2. create filetype for current.
--        3. open file at position of snippet
--        4. open file at `new_snippet` first/last??
--
--        >>> reuse actions/commands from dui
--
--
--      - UPON ENTER SNIPPETS FILE:
--
--        trigger a snippet in position so that the user gets put
--        directly into a new snippet snippet.
--
--      - DYNAMIC SNIPPET HELPER SNIPPET
--
--        use dynamic snippet that allows user to get a custom streamlined
--        experience for creating snippets.
--
--
--      - CREATE SNIPPET FROM VISUAL SELECTION / TREESITTER NODE EXPANSION
--
--        ui workflow for easilly selecting code that should go into a dynamic
--        snippet for easy dynamic reuse.

local PATHS = {
	sep_lua = ".",
	sep_sys = "/", -- how is this done in doom?
	lua_all = "**/*.lua",
	lua_ext = ".lua",
	lua_pre = "lua/",
}

-- TODO: paths to check for

local settings = {
	defaults = {
		-- move these out
		snippets_path_user = "lua/snippets", -- rename: default
		sys_path = "lua/snippets",
		lua_path = "snippets",
		---
		paths = {}, -- user supplied paths
		use_default_path = true,
		use_personal = false,
		use_internal = false, -- load snippets provided by `luasnip_snippets`
		ft_personal_use_only = {}, -- which filetypes do I want to have load
		ft_internal_use_only = {},
		ft_dont_use = {},
	},
	snippets_path_internal = "lua/luasnip_snippets/snippets",
	snippets_mod_path_internal = "luasnip_snippets.snippets",
}

-- BUG: this one matches improperly for subdirs
--  a:  /Users/hjalmarjakobsson/.config/nvim/lua/user/snippets/lua/init.lua
--    user.snippets
--      init
--        b: user.snippets.init
--  a:  /Users/hjalmarjakobsson/.config/nvim/lua/user/snippets/lua/print.lua
--    user.snippets
--      print
--        b: user.snippets.print
local function get_file_name(file)
	-- lua/init.lua -> init.lua
	--
	-- /snippets/ (...) .lua
	local s, e, f = file:find("/snippets/(.-)%.lua$")
	return f
	-- return file:match("^.+/(.+)$")
end

local function snip_module_has_string_keys(sm)
	for k, _ in pairs(sm) do
		if type(k) == "string" then
			return true
		end
	end
	return false
end

local function get_ft_from_mod_path(mod_path)
	local _, _, ft_found = mod_path:find("%.snippets%.([_%w]-)%.") --([_%w]-)")
	if not ft_found then
		_, _, ft_found = mod_path:find("%.snippets%.([_%w]-)$") --([_%w]-)")
	end
	return ft_found
end

----
--
--
-- TODO: make it so that these functions can be reused below when filtering
-- modules so that it can be used on just a single filename string.

local function check_use_only(opts, mp)
	if type(opts.ft_use_only) ~= "table" or #opts.ft_use_only == 0 then
		return true
	end
	for _, ft in pairs(opts.ft_use_only) do
		if mp:match("snippets." .. ft) then
			return true
		end
	end
	return false
end

local function filter_by_ft(opts, mp)
	if type(opts.ft_filter) ~= "table" or #opts.ft_use_only == 0 then
		return true
	end
	for _, ft in pairs(opts.ft_filter) do
		if mp:match("snippets." .. ft) then
			return false
		end
	end
	return true
end

local function get_snippet_modpaths(opts)
	local t_snippet_modules = {}
	if opts.use_default_path then
		local default_paths =
			vim.api.nvim_get_runtime_file(settings.defaults.sys_path .. PATHS.sep_sys .. PATHS.lua_all, true)
		for _, dp in ipairs(default_paths) do
			local mp = settings.defaults.lua_path .. PATHS.sep_lua .. get_file_name(dp)
			table.insert(t_snippet_modules, mp)
		end
	end

	if opts.paths then
		for _, user_path in ipairs(opts.paths) do
			local up = PATHS.lua_pre .. user_path .. PATHS.sep_sys .. PATHS.lua_all
			local t_paths = vim.api.nvim_get_runtime_file(up, true)
			for _, snippets_file_path in ipairs(t_paths) do
				local pre = user_path:gsub(PATHS.sep_sys, ".")
				local post = get_file_name(snippets_file_path):gsub(PATHS.sep_sys, ".") --:sub(1, -5)
				local full_path = pre .. PATHS.sep_lua .. post
				table.insert(t_snippet_modules, full_path)
			end
		end
	end

	if opts.use_internal then
		local luasnip_snippets_paths =
			vim.api.nvim_get_runtime_file(settings.snippets_path_internal .. PATHS.sep_sys .. PATHS.lua_all, true)
		for _, path in ipairs(luasnip_snippets_paths) do
			local mp = settings.snippets_mod_path_internal .. PATHS.sep_lua .. get_file_name(path)
			table.insert(t_snippet_modules, mp)
		end
	end
	return t_snippet_modules
end

local function get_snippets(opts, t_snippet_modpaths)
	local snippets_by_ft = {}
	for _, mod_path in ipairs(t_snippet_modpaths) do
		if mod_path:find("%.init$") then
			mod_path = string.sub(mod_path, 1, string.len(mod_path) - 5)
			-- print("sub:", mod_path)
		end
		-- print(mod_path)
		local sm = require(mod_path)
		if type(sm) == "table" then
			if snip_module_has_string_keys(sm) then
				for ft, snips in pairs(sm) do
					-- add to main table
					if not snippets_by_ft[ft] then
						snippets_by_ft[ft] = {}
					end
					for _, s in pairs(snips) do
						table.insert(snippets_by_ft[ft], s)
					end

					-- if check_use_only(opts, mod_path) and filter_by_ft(opts, mod_path) then
					-- 	if log then
					-- 		print(mod_path)
					-- 	end
					-- 	load(ft, snips)
					-- end
				end
			else
				local ft = get_ft_from_mod_path(mod_path)
				if not ft then
					print("LuaSnip-snippets: Could not compute filetype for module: " .. mod_path)
				else
					if not snippets_by_ft[ft] then
						snippets_by_ft[ft] = {}
					end
					for _, s in pairs(sm) do
						table.insert(snippets_by_ft[ft], s)
					end

					-- if check_use_only(opts, mod_path) and filter_by_ft(opts, mod_path) then
					-- 	if log then
					-- 		print(mod_path)
					-- 	end
					-- 	-- print(ft, mod_path)
					-- 	load(ft, sm)
					-- end
				end
			end
		end
	end

	return snippets_by_ft
end

------
--
--

function M.setup(opts)
	local log = false
	if log then
		print("luasnip_snippets.setup()")
	end
	opts = vim.tbl_deep_extend("force", settings.defaults, opts or {})
	local t_snippet_modpaths = get_snippet_modpaths(opts)

	-- for _, path in ipairs(t_snippet_modules) do
	-- 	print("snippet path:", path)
	-- 	-- print(vim.inspect(t_snippet_modules)) --
	-- end

	local snippets_by_ft = get_snippets(opts, t_snippet_modpaths)

	-- for _, mod_path in ipairs(t_snippet_modpaths) do
	--
	-- 	if mod_path:find("%.init$") then
	-- 		mod_path = string.sub(mod_path, 1, string.len(mod_path) - 5)
	-- 		-- print("sub:", mod_path)
	-- 	end
	-- 	-- print(mod_path)
	-- 	local sm = require(mod_path)
	-- 	if type(sm) == "table" then
	-- 		if snip_module_has_string_keys(sm) then
	-- 			for ft, snips in pairs(sm) do
	-- 				-- add to main table
	-- 				if not snippets_by_ft[ft] then
	-- 					snippets_by_ft[ft] = {}
	-- 				end
	-- 				for _, s in pairs(snips) do
	-- 					table.insert(snippets_by_ft[ft], s)
	-- 				end
	--
	-- 				if check_use_only(opts, mod_path) and filter_by_ft(opts, mod_path) then
	-- 					if log then
	-- 						print(mod_path)
	-- 					end
	-- 					load(ft, snips)
	-- 				end
	-- 			end
	-- 		else
	-- 			local ft = get_ft_from_mod_path(mod_path)
	-- 			if not ft then
	-- 				print("LuaSnip-snippets: Could not compute filetype for module: " .. mod_path)
	-- 			else
	-- 				if not snippets_by_ft[ft] then
	-- 					snippets_by_ft[ft] = {}
	-- 				end
	-- 				for _, s in pairs(sm) do
	-- 					table.insert(snippets_by_ft[ft], s)
	-- 				end
	--
	-- 				if check_use_only(opts, mod_path) and filter_by_ft(opts, mod_path) then
	-- 					if log then
	-- 						print(mod_path)
	-- 					end
	-- 					-- print(ft, mod_path)
	-- 					load(ft, sm)
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- -- TODO: move loading to here
	-- -- P(snippets_by_ft, {depth=1})
	-- --
	-- --
	-- -- now I could move to here and then
	for ft, snips in pairs(snippets_by_ft) do
		load(ft, snips)
		-- if check_use_only(opts, mod_path) and filter_by_ft(opts, mod_path) then
		-- 	if log then
		-- 		print(mod_path)
		-- 	end
		-- 	load(ft, snips)
		-- end
	end

	return t_snippet_modules
end

return M
