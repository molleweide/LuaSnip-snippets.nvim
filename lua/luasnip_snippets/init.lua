local M = {}

-- copy path utils from doom so that it becomes a bit easier to manage where user puts his or her own
-- files
--
--

-- TODO: setup()
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

function M.setup(opts)
	-- is it possible to select any path.
	--
	-- default path
	if opts.snippets_path_user then
	  print("user snip path:", opts.snippets_path_user)
	else
	end

	if opts.use then
		-- for each use string
	  print("user snip use:", vim.inspect(opts.use))
	else
	  -- load all snippets
	end

	print("load luasnip_snippets xxxx yyyyy")

	local t = {}

	local nvim_snippets = vim.api.nvim_get_runtime_file(snippets_path_user .. "*.lua", true)
	local luasnip_snippets = vim.api.nvim_get_runtime_file(snippets_path_internal .. "*.lua", true)

	t = insert_snippets_into_table(t, nvim_snippets_modules, nvim_snippets)
	t = insert_snippets_into_table(t, luasnip_snippets_modules, luasnip_snippets)

	return t
end

return M
