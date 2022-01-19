# luasnip-lib

This is a plugin that aims to provide a community driven library of [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snipets and also make it easy to add LuaSnip snippets to neovim

## Installation

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use({
        "L3MON4D3/LuaSnip",
        event = "BufReadPre",
        wants = "friendly-snippets",
        config = require("path.to.config.below"),
        requires = {
        "rafamadriz/friendly-snippets",
        -- "molleweide/moll-snippets.nvim",
        },
        })

```

## Config

This snippet solely aims to show how you hook [LuaSnip](https://github.com/L3MON4D3/LuaSnip) into your config. Be sure to check out `LuaSnip` repo for further configurations.

    ```lua
return function()

    local luasnip = require("luasnip")

    -- be sure to load this before vscode snippets
    luasnip.snippets = require("luasnip-snippets").load_snippets()

    require("luasnip/loaders/from_vscode").load()

    end
    ```

## User snippets

    `LuaSnip-snippets` will comes with pre-installed snippets but you can also add your own snippets by putting a lua file under `lua/snippets/my-snippet-file.lua` in your `vimrc` directory.

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

## todo

| title  | description |
| ------------- | ------------- |
| add credits  | during the initial development I crawled github for various snippets. Authors need to be credited approtriately.  |
| helpers  | Add more helper snippets for making it easy to create luasnippets which can seem rather daunting at first.  |

