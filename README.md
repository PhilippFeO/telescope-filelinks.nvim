# telescope-filelinks.nvim
Add file links to your (N)Vim wiki or files (like a `README.md`) in general using telescope.

## Usage
By using the function `make_filelink` via
```vim
:Telescope filelinks make_filelink
```
a telescope file picker opens an lets you choose the file you want to link. After hitting `<CR>` a string according to `format_string` (default is `"[%s](%s)"` for `md` files) is added to your document, for example: The file `~/wiki/nvim/plugins.md` becomes `[Plugins](~/wiki/nvim/plugins.md)`.

## Installation
### Lazy.nvim
```lua
'PhilippFeO/telescope-filelinks.nvim'
```
### packer
```lua
use { 'PhilippFeO/telescope-filelinks.nvim' }
```

## Setup
```lua
require('telescope').load_extension('filelinks')
local filelinks = require('telescope').extensions['filelinks']
filelinks.setup({
    -- s. section 'Options'
})
```
It probably makes sense to create a keybinding, for instance
```lua
vim.keymap.set('n', '<Leader>ml', filelinks.make_filelink, { desc = '[m]ake file [l]ink' })
```

### Options
The following options (with their defaults) are currently availabe:
```lua
-- The working directory to search for files.
-- Set to your wiki directory to create links (further examples below)
working_dir = vim.fn.getcwd(),
-- First letter in display name upper or lower case, i.e. `[Plugins](…)`
-- or `[plugins](…)`
first_upper = true,
-- Format string for inserting file links. Default is Markdown syntax.
-- When you are using some wiki syntax, change it to its syntax.
-- Lua regex is used. Formatting only works when there are exactly two
-- `%s`. Currently, no checks for a proper Lua regex are performed, so
-- keep an eye on having exactly two `%s` and nothing else/more.
format_string = '[%s](%s)', 
-- Title for the telescope prompt
prompt_title = 'File Finder',
-- Display file links with or without extension, f. i. `[Plugins](…)`
-- or `[Plugins.lua](…)`
remove_extension = true,
```

#### Options for `make_filelink`
The function `make_filelink` takes an `opts` table where you can (but don't have to) specify `working_dir` and `format_string` (the meaning is the same as in [Options](#options)). The goal behind this is to be able to use `make_filelink` in additional contexts next to linking files in a wiki, s. [Usecase besides in wiki contexts](#usecase-besides-in-wiki-contexts).

# Examples
## Configuration
```lua
filelinks.setup({
    working_dir = '~/Documents/wiki'
    prompt_title = 'Markdown File Finder' 
})
```

## Usecase besides in wiki contexts
You can use the picker to create links in any other directory. For this purpose leave the `working_dir` unchanged. An example usecase where this might be useful is the following: You have set up `telescope-filelinks.nvim` for your wiki with the keymap shown above. Because you are a highly productive open source developer, you write regularly to `md` files like a `README.md`. With the following keymap
```lua
vim.keymap.set('n', '<Leader>mc', function()
  filelinks.make_filelink({
    working_dir = vim.fn.getcwd(),
    format_string = '[%s](%s)'
  })
end, { desc = '[m]ake link in [c]urrent dir' })
```
you can easily add file links to the `README.md` although you might have defined another format string for your wiki.
