local M = {}

-- copy path utils from doom so that it becomes a bit easier to manage where user puts his or her own
-- files
--
--

-- TODO: require(luasnip_snippets).setup{}
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

-- TODO: MERGE TABLES INSTEAD IF INSERTING!
-- i should use vim tbl extend here so that one can load snippets more easilly
-- and in a more separated manner rather than overwriting.
--
-- this would allow for a require("luasnip_snippets").setup()
-- and then all snippets would nicely be merged into the table.
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

-- TODO: setup() pattern
-- 1. rename this to setup and follow the pattern that many other plugins does.
-- allow user to pass table containing list of paths where user would like to be able
-- to store snippets.
--
-- 2. allow user to select which filetypes she wants to merge into the luasnip table.
--    this makes sense since the snippets library can grow very large over time and so
--    it makes sense to allow user to select this.
--    default = merge all
--
-- 3.
function M.load_snippets(opts)
	-- is it possible to select any path.
	--
	-- default path
	if opts.snippets_path_user then
	else
	end

	if opts.use then
		-- for each use string
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
