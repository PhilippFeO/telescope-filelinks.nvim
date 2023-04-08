local builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Dafault values
local defaults = {
  -- find_command = { "rg", "--files", "--color", "never" },
  first_upper = true,
  format_string = "[%s](%s)",
  format_string_append = " ", -- append space for better typography and continuous typing
  prompt_title = "File Finder",
  remove_extension = true,
  working_dir = vim.fn.getcwd(),
}

local M = {}

M.setup = function(opts)
  -- cwd not working_dir because telescope's finders.new_oneshot_job
  -- logic needs the cwd field.
  defaults.working_dir = opts.working_dir or defaults.working_dir
  -- defaults.find_command = opts.find_command or defaults.find_command
  defaults.first_upper = opts.first_upper or defaults.first_upper
  defaults.format_string = opts.format_string or defaults.format_string
  defaults.format_string_append = opts.format_string_append or defaults.format_string_append
  defaults.prompt_title = opts.prompt_title or defaults.prompt_title
  defaults.remove_extension = opts.remove_extension or defaults.remove_extension
end

M.make_filelink = function(opts)
  -- make_filelink can receive all default values but also a subset.
  local fopts = {} -- fopts = function opts
  if opts then
    -- To work properly in the subset case, the missing default values have to be added..
    for k, v in pairs(defaults) do
      fopts[k] = v
    end
    -- ..i. e. overwritten by opts
    for k, v in pairs(opts) do fopts[k] = v end
  else
    -- make_filelink was called without any argument, i. e. opts = nil
    fopts = defaults
  end
  builtin.find_files({
    prompt_title = fopts.prompt_title,
    cwd = fopts.working_dir or fopts.working_dir,
    -- find_command = fopts.find_command,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Extract file name via removing everthing before last /
        local file_name = selection[1]:gsub(".*/", "")
        -- remove file extension
        if fopts.remove_extension then
          file_name = file_name:gsub("%..*", "")
        end
        -- convert first letter to uppercase for proper readability
        if fopts.first_upper then
          file_name = file_name:gsub("^%l", string.upper)
        end
        -- Put <file_name> & <selection> at current position (=nvim_put)
        local format_string = fopts.format_string .. fopts.format_string_append
        print('format_string: ' .. format_string)
        vim.api.nvim_put({ string.format(format_string, file_name, selection[1]) }, "", false, true)
      end)
      return true
    end,
  })
end

return M
