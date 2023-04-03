local builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Dafault values
local defaults = {
  -- find_command = { "rg", "--files", "--color", "never" },
  first_upper = true,
  format_string = "[%s](%s)",
  prompt_title = "File Finder",
  remove_extension = true,
  working_dir = vim.fn.getcwd(),
}

local M = {}

M.setup = function(opts)
  -- `cwd` not `working_dir` because telescope's finders.new_oneshot_job
  -- logic needs the `cwd` field.
  defaults.working_dir = opts.working_dir or defaults.working_dir
  -- defaults.find_command = opts.find_command or defaults.find_command
  defaults.first_upper = opts.first_upper or defaults.first_upper
  defaults.format_string = opts.format_string or defaults.format_string
  defaults.prompt_title = opts.prompt_title or defaults.prompt_title
  defaults.remove_extension = opts.remove_extension or defaults.remove_extension
end

M.make_filelink = function(opts)
  -- In case `make_filelink` is called without an argument
  opts = opts or {}
  local format_string = opts.format_string or defaults.format_string
  builtin.find_files({
    prompt_title = defaults.prompt_title,
    cwd = opts.working_dir or defaults.working_dir,
    -- find_command = defaults.find_command,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Extract file name via removing everthing before last /
        local file_name = selection[1]:gsub(".*/", "")
        -- remove file extension
        if defaults.remove_extension then
          file_name = file_name:gsub("%..*", "")
        end
        -- convert first letter to uppercase for proper readability
        if defaults.first_upper then
          file_name = file_name:gsub("^%l", string.upper)
        end
        -- Put <file_name> & <selection> at current position (=nvim_put)
        vim.api.nvim_put({ string.format(format_string, file_name, selection[1]) }, "", false, true)
      end)
      return true
    end,
  })
end

return M
