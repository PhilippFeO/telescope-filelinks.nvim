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
  url_first = false,
  working_dir = vim.fn.getcwd(),
}

local M = {}

M.setup = function(opts)
  -- merge setup values into defualts list
  for k, v in pairs(opts) do defaults[k] = v end
end

M.make_filelink = function(opts)
  -- make_filelink can receive all default values but also a subset.
  local fopts = {} -- fopts = function opts
  if opts then
    -- To work properly in the subset case, the missing default values have to be added..
    -- You can't just overwrite the defaults because users might set them explicitly and rely on them.
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
    -- not needed in defaults because builtin.find_files handles empty/nil find_command option on its own
    find_command = fopts.find_command,
    prompt_title = fopts.prompt_title,
    -- cwd not working_dir because telescope's finders.new_oneshot_job
    -- logic needs the cwd field.
    cwd = fopts.working_dir,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selected_page = action_state.get_selected_entry()
        -- Extract file name via removing everthing before last /
        local file_name = selected_page[1]:gsub(".*/", "")
        -- remove file extension
        if fopts.remove_extension then
          file_name = file_name:gsub("%..*", "")
        end
        -- convert first letter to uppercase for proper readability
        if fopts.first_upper then
          file_name = file_name:gsub("^%l", string.upper)
        end
        -- Put <file_name> & <selected_page> at current position (=nvim_put)
        local format_string = fopts.format_string .. fopts.format_string_append
        -- Some link schemes like Wiki, Orgmode or AsciiDoc expect the URL to come first
        if fopts.url_first then
          vim.api.nvim_put({ string.format(format_string, selected_page[1], file_name) }, "", false, true)
        else -- Description first
          vim.api.nvim_put({ string.format(format_string, file_name, selected_page[1]) }, "", false, true)
        end
      end)
      return true
    end,
  })
end

return M
