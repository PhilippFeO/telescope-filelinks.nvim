# telescope-filelinks.nvim
Add file links to your wiki, the `README.md` or any other file using telescope.

## Usage
By using the function `make_filelink` via
```vim
:Telescope filelinks make_filelink
```
a telescope file picker opens an lets you choose the file you want to link. After hitting `<CR>` a string according to `format_string` (default is `"[%s](%s)"` for `md` files) is added to your document, for example: The file `lua/filelinks/init.lua` becomes `[Init](lua/filelinks/init.lua)`.

There might be scenarios, where you have to prepend `./` or `/` to the path string, i. e. using `[%s](/%s)` instead of `[%s](%s)`.

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
-- insert mode for writing continuously
vim.keymap.set('i', '<C-l>', filelinks.make_filelink, { desc = '[<C>]reate [l]ink in Insert Mode' })
-- normal mode
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
-- Append space to format_string for better typography and continuous typing
format_string_append = " ",
-- Title for the telescope prompt
prompt_title = 'File Finder',
-- Display file links with or without extension, f. i. `[Plugins](…)`
-- or `[Plugins.lua](…)`
remove_extension = true,
-- Some link schemes like Wiki, Orgmode or AsciiDoc expect the URL first
-- and the displayed text second. Markdown's order is vice versa. By
-- setting to true URL first schemes are possible.
url_first = true
```

#### Options for `make_filelink`
The function `make_filelink` takes a table as input where you can overwrite the default values. This might be useful when you want to use the plugin in additional contexts, for instance for writing `README.md` files, s. [Usecase besides wiki contexts](#usecase-besides-wiki-contexts).

# Examples
## Configuration
```lua
filelinks.setup({
    working_dir = '~/Documents/wiki'
    prompt_title = 'Markdown File Finder' 
})
```

## Usecase besides wiki contexts
You can use the picker to create links in any other directory. For this purpose leave the `working_dir` unchanged. An example usecase where this might be useful is the following: You have set up `telescope-filelinks.nvim` for your wiki with the keymap shown above. Because you are a highly productive open source developer, you write regularly to `md` files like a `README.md`. With the following keymap
```lua
vim.keymap.set('n', '<Leader>mc', function()
  filelinks.make_filelink({
    working_dir = vim.fn.getcwd(),
    format_string = '[%s](%s)',
    remove_extension = false
  })
end, { desc = '[m]ake link in [c]urrent dir' })
```
you can easily add file links to the `README.md` although you might have defined another format string for your wiki in the `setup` function.
