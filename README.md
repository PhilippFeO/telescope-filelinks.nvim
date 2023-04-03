# telescope-filelinks.nvim
Add file links to your (N)Vim Wiki or README.md using telescope.

## Usage
By using the function `make_filelink` via
```vim
:Telescope filelinks make_filelink
```
a telescope file picker opens an lets you choose the file you want to link. After hitting `<CR>` a string according to `format_string` (default is `[%s](%s)` for `md` files) is added to your document, for example: The file `~/wiki/nvim/plugins.md` becomes `[Plugins](~/wiki/nvim/plugins.md)`.

<!-- TODO: Section 'Installation', compare https://github.com/debugloop/telescope-undo.nvim#installation <03-04-2023> -->
## Installation
TODO, I'm sorry.

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
vim.keymap.set('n', '<Leader>ml', filelinks.make_file_link, { desc = '[m]ake file [l]ink' })
```

### Options
The following options (with their defaults) are currently availabe:
```lua
-- You current wiki directory. I strongly recommend to set this option.
wiki_dir = '~/wiki.vim',
-- Command to use for searching files (copied from telescope's `find_files`,
-- so it should work out of the box)
find_command = { 'rg', '--files', '--color', 'never' },
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
#### Example configuration
```lua
filelinks.setup({
    wiki_dir = '~/Documents/wiki'
    prompt_title = 'Markdown File Finder' 
})
```
