local load = require("luasnip").add_snippets

local M = {}

-- TODO:
--
--      - REFACTOR: paths so that the for loops get a little bit more cleaned
--                  up
--
--              get all snippet modules()
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

local function get_file_name(file)
	local _, _, f = file:find("/snippets/(.-)%.lua$")
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
			table.insert(t_snippet_modules, {
				origin_path = dp,
				mod_path = settings.defaults.lua_path .. PATHS.sep_lua .. get_file_name(dp),
			})
		end
	end

	if opts.use_personal then
		for _, user_path in ipairs(opts.paths) do
			local up = PATHS.lua_pre .. user_path .. PATHS.sep_sys .. PATHS.lua_all
			local t_paths = vim.api.nvim_get_runtime_file(up, true)
			for _, dp in ipairs(t_paths) do
				local pre = user_path:gsub(PATHS.sep_sys, ".")
				local post = get_file_name(dp):gsub(PATHS.sep_sys, ".") --:sub(1, -5)
				-- table.insert(t_snippet_modules, full_path)
				table.insert(t_snippet_modules, {
					origin_path = dp,
					mod_path = pre .. PATHS.sep_lua .. post,
				})
			end
		end
	end

	if opts.use_internal then
		local luasnip_snippets_paths =
			vim.api.nvim_get_runtime_file(settings.snippets_path_internal .. PATHS.sep_sys .. PATHS.lua_all, true)
		for _, dp in ipairs(luasnip_snippets_paths) do
			table.insert(t_snippet_modules, {
				origin_path = dp,
				mod_path = settings.snippets_mod_path_internal .. PATHS.sep_lua .. get_file_name(dp),
			})
		end
	end
	return t_snippet_modules
end

local function get_snippets(opts, t_snippet_modpaths)
	local snippets_by_ft = {}
	for _, t in ipairs(t_snippet_modpaths) do
		local mod_path = t.mod_path
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
						s["filetype"] = ft
						s["origin_file_path"] = t.origin_path
						s["origin_file_mod_path"] = t.mod_path
						table.insert(snippets_by_ft[ft], {
							snip = s,
							origin_path = t.origin_path,
							mod_path = t.mod_path,
						})
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
						-- table.insert(snippets_by_ft[ft], s)
						s["filetype"] = ft
						s["origin_file_path"] = t.origin_path
						s["origin_file_mod_path"] = t.mod_path
						table.insert(snippets_by_ft[ft], {
							snip = s,
							origin_path = t.origin_path,
							mod_path = t.mod_path,
						})
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

M.get_all_snippets_final = function(opts)
	opts = vim.tbl_deep_extend("force", settings.defaults, opts or {})

	P(opts)

	local t_snippet_modpaths = get_snippet_modpaths(opts)

	return get_snippets(opts, t_snippet_modpaths)
end

M.flatten_snippets = function(ts)
	local flatten_snips = {}
	for ft, t_snips in pairs(ts) do
		for _, s in pairs(t_snips) do
			s["filetype"] = ft
			table.insert(flatten_snips, s)
		end
	end
	return flatten_snips
end

M.get_snippets_flat = function(opts)
	local t_snippets = M.get_all_snippets_final(opts) --get_snippets(opts, t_snippet_modpaths)

	return M.flatten_snippets(t_snippets)
end

M.load_snips = function(ts)
	local ls = require("luasnip")
	local parse = ls.snippet

	for ft, t_snips in pairs(ts) do
		local flatten_snips = {}
		for _, s in pairs(t_snips) do
			table.insert(flatten_snips, s.snip)

			-- P(s.snip, { depth = 1 })

			-- P(s.snip)

			-- table.insert(
			-- 	flatten_snips,
			-- 	s.snip[4] and s.snip[4](s.snip[1], s.snip[2], s.snip[3]) or parse(s.snip[1], s.snip[2], s.snip[3])
			-- )
		end

		-- TODO: transform the table into s(...)

		-- if func -> load else if table -> transform

		load(ft, flatten_snips)
		-- if check_use_only(opts, mod_path) and filter_by_ft(opts, mod_path) then
		-- 	if log then
		-- 		print(mod_path)
		-- 	end
		-- 	load(ft, snips)
		-- end
	end
end

------
--
--

function M.setup(opts)
	local log = false
	if log then
		print("luasnip_snippets.setup()")
	end

	local t_snippets = M.get_all_snippets_final(opts) --get_snippets(opts, t_snippet_modpaths)

	-- P(t_snippets, { depth = 4})

	M.load_snips(t_snippets)

	return t_snippets
end

return M
