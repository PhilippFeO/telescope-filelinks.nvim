local builtin = require "telescope.builtin"
-- local pickers = require "telescope.pickers"
-- local finders = require "telescope.finders"
-- local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Dafault values
local defaults = {
  -- find_command = { "rg", "--files", "--color", "never" },
  find_command = "",
  first_upper = true,
  format_string = "[%s](%s)",
  prompt_title = "File Finder",
  remove_extension = true,
  wiki_dir = "~/wiki.vim/",
}

local M = {}

M.opts = {}

M.setup = function(opts)
  -- `cwd` not `wiki_dir` because telescope's finders.new_oneshot_job
  -- logic needs the `cwd` field.
  M.opts.cwd = opts.wiki_dir or defaults.wiki_dir
  -- M.opts.find_command = opts.find_command or defaults.find_command
  M.opts.first_upper = opts.first_upper or defaults.first_upper
  M.opts.format_string = opts.format_string or defaults.format_string
  M.opts.prompt_title = opts.prompt_title or defaults.prompt_title
  M.opts.remove_extension = opts.remove_extension or defaults.remove_extension
end

M.make_filelink = function()
  -- In case `make_filelink` is called without an argument
  builtin.find_files({
    prompt_title = M.opts.prompt_title,
    cwd = M.opts.cwd,
    -- find_command = M.opts.find_command,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Extract file name via removing everthing before last /
        local file_name = selection[1]:gsub(".*/", "")
        -- remove file extension
        if M.opts.remove_extension then
          file_name = file_name:gsub("%..*", "")
        end
        -- convert first letter to uppercase for proper readability
        if M.opts.first_upper then
          file_name = file_name:gsub("^%l", string.upper)
        end
        -- Put <file_name> & <selection> at current position (=nvim_put)
        vim.api.nvim_put({ string.format(M.opts.format_string, file_name, selection[1]) }, "", false, true)
      end)
      return true
    end,
  })
end

return M
