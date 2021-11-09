# Togglr

Togglr is a vim plugin that toggles values (by pressing `<Leader>tw` in normal mode):

- true &harr; false
- on &harr; off
- enabled &harr; disabled
- left &harr; right
- top &harr; bottom
- margin-left &harr; margin-right
- etc...

## Installation

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'elentok/togglr.vim',
  config = function()
    require('togglr').setup()
  end
}
```

Customization:

```lua
require('togglr').setup({

  -- Specify key map (set to "false" to disable)
  key = "<Leader>tw",

  -- Specify which register to use (to avoid overriding the default register)
  register = "t",

  -- Add custom sets to values to toggle between
  values = {
    ["value"] = "opposite-value",
  },
})
```

If after the initial setup you want to add more values:

```lua
require('togglr').add('value', 'opposite-value')
```
