# LuaSnip-snippets

This is a plugin that aims to provide a community driven library of [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snipets and also make it easy to add LuaSnip snippets to neovim

## Installation

The following is an [example](https://github.com/NTBBloodbath/doom-nvim/blob/main/lua/doom/modules/init.lua) of how LuaSnip is installed in [doom-nvim](https://github.com/NTBBloodbath/doom-nvim) with the [packer](https://github.com/wbthomason/packer.nvim) package manager.

```lua
  use({
    "hrsh7th/nvim-cmp",
    commit = pin_commit("2e4270d02843d15510b3549354e238788ca07ca5"),
    wants = { "LuaSnip" },
    requires = {
      {
        "L3MON4D3/LuaSnip",
        commit = pin_commit("a54b21aee0423dbdce121c858ad6a88a58ef6e0f"),
        event = "BufReadPre",
        wants = "friendly-snippets",
        config = require("doom.modules.config.doom-luasnip"),
        disable = disabled_snippets,
        requires = {
          "rafamadriz/friendly-snippets",
          "luasnip_snippets.nvim",
        },
      },
      {
        "windwp/nvim-autopairs",
        commit = pin_commit("e6b1870cd2e319f467f99188f99b1c3efc5824d2"),
        config = require("doom.modules.config.doom-autopairs"),
        disable = disabled_autopairs,
        event = "BufReadPre",
      },
    },
    config = require("doom.modules.config.doom-cmp"),
    disable = disabled_lsp,
    event = "InsertEnter",
  })
 })
```

## Config

This snippet solely aims to show how you hook [LuaSnip](https://github.com/L3MON4D3/LuaSnip) into your config. Be sure to check out `LuaSnip` repo for further configurations.

```lua
return function()

    local luasnip = require("luasnip")

    -- be sure to load this first since it overwrites the snippets table.
    luasnip.snippets = require("luasnip_snippets").load_snippets()

    ...
    ...
end
```

## User snippets

You add your own snippets by putting a lua file under `lua/snippets/my-snippet-file.lua` in your `vimrc` directory.

## How to compose snippets

Here follows an example of a snippet file that you can put inside your `lua/snippets` directory. As you can see below the snippets are assigned to their respective language key, and hence if you like you can either put all your snippets into their own file or you can put all of your snippets in a single file - just be sure to assign them to the correct language key.

```lua
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local r = require("luasnip.extras").rep

    return {
	    lua = {
            s("print_str", {
                    t("print(\""),
                    i(1, "desrc"),
                    t("\")"),
                    }),
            s("print_var1", {
                    t("print(\""),
                    i(1, "desrc"),
                    t(": \" .. "),
                    i(2, "the_variable"),
                    t(")"),
                    }),
            s("print_var2", {
                    t("print(\""),
                    i(1, "the_variable"),
                    t(": \" .. "),
                    r(1),
                    t(")"),
                    }),
            s("print_var3", {
                    t("print(\""),
                    i(1, "desrc"),
                    t(" | "),
                    i(2, "the_variable"),
                    t(" : \" .. "),
                    r(2),
                    t(")"),
                    }),
	    }
    }
```

## Feel free to submit a PR.

I encourage anyone who wants to submit their own snippets. At the moment this plugin is quite small but it has some handy snippets already. If you decide to submit snippets please add them to their appropriate language file if it exists or create a new one if necessary. Otherwise please provide a good explanation for why you have grouped multiple language snippets into one file.

## TODO

| title  | description |
| --------| ------------- |
| setup   | move away from refering to how doom-nvim installs LuaSnip to a simple general installer instructions. |
| credits | during the initial development I crawled github for various snippets. Authors need to be credited approtriately. |
| helpers | Add more helper snippets for making it easy to create luasnippets which can seem rather daunting at first. |

