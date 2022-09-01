local ls = require("luasnip")

local M = {}

-- 1. copy path utils doom system and paste below
-- 2. put all paths path segments in table below.
-- 3. print everything.
-- 4. read luasnip manual again.

-- TODO: setup()
local settings = {
	snippets_path_user = "lua/snippets/", -- rename: default
	snippets_path_internal = "lua/luasnip_snippets/snippets/",
	nvim_snippets_modules = "snippets.",
	luasnip_snippets_modules = "luasnip_snippets.snippets.",
}
local snippets_path_user = "lua/snippets/"
local snippets_path_internal = "lua/luasnip_snippets/snippets/"

-- in-lua path prefixes
local nvim_snippets_modules = "snippets."
local luasnip_snippets_modules = "luasnip_snippets.snippets."

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
	-- local luasnip_snippets = vim.api.nvim_get_runtime_file(snippets_path_internal .. "*.lua", true)
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
	local snippet_source_paths
	if opts.use then
		-- for each use string
		print("user snip use:", vim.inspect(opts.use))
	else
		-- load all snippets
	end

	print("load luasnip_snippets xxxx yyyyy")

	local t = {}

	--
	-- 1: GET USER SNIPPET FILE PATHS
	--

	if opts.paths then
		print("user snip path:", vim.inspect(opts.paths))

		for _, user_path in ipairs(opts.paths) do
			local t_paths = vim.api.nvim_get_runtime_file(user_path .. "*.lua", true)
			for _, snippets_file_path in ipairs(t_paths) do
				table.insert(snippet_source_paths, snippets_file_path)
			end
		end
	else
		-- DEFAULT CASE: use `lua/snippets/`
		table.insert(snippet_source_paths, vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true))
	end

	--
	-- 2: GET INTERNAL SNIPPETS
	--

	local luasnip_snippets_paths = vim.api.nvim_get_runtime_file(snippets_path_internal .. "*.lua", true)
	for _, path in ipairs(luasnip_snippets_paths) do
		table.insert(snippet_source_paths, path)
	end

	------------
	print("snippet_source_paths >>>", vim.inspect(snippet_source_paths))
	------------

	--
	-- 3: COMPILE ALL SNIPETS INTO ONE LARGE SNIPPETS TABLE BY FILETYPE
	--

  -- a. for each snippets file.
  -- b. for each filetype.
  --
  -- vim.tbl_deep_extend() use this to make it easier to merge all tables.

	-- extend_luasnip_with_snippets()
	-- t = insert_snippets_into_table(t, nvim_snippets_modules, nvim_snippets)

	-- t = insert_snippets_into_table(t, luasnip_snippets_modules, luasnip_snippets)


  -- FIX: MAKE THIS WORK AND PRINT AFTERWARDS
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

	--
	-- 4: LOAD SNIPPETS INTO LUASNIP.
	--

	for ft, ft_snippets in pairs(t_all_snippets) do

	end

	-- return t
end

return M
