local builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Dafault values
local defaults = {
  -- find_command = { "rg", "--files", "--color", "never" },
  first_upper = false,
  format_string = "[%s](%s)",
  format_string_append = " ", -- append space for better typography and continuous typing
  prepend_to_link = "",
  prompt_title = "File Finder",
  remove_extension = true,
  url_first = false,
  working_dir = vim.fn.getcwd(),
}

local M = {}

M.setup = function(opts)
  -- merge setup values into defualts list
  defaults = vim.tbl_extend('force', defaults, opts)
end

M.make_filelink = function(opts)
  -- make_filelink can receive all default values but also a subset.
  opts = vim.tbl_extend('keep', opts, defaults)
  builtin.find_files({
    -- not needed in defaults because builtin.find_files handles empty/nil find_command option on its own
    find_command = opts.find_command,
    prompt_title = opts.prompt_title,
    -- cwd not working_dir because telescope's finders.new_oneshot_job
    -- logic needs the cwd field.
    cwd = opts.working_dir,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selected_page = action_state.get_selected_entry()
        -- Extract file name via removing everthing before last /
        local file_name = selected_page[1]:gsub(".*/", "")
        -- remove file extension
        if opts.remove_extension then
          file_name = file_name:gsub("%..*", "")
        end
        -- convert first letter to uppercase for proper readability
        if opts.first_upper then
          file_name = file_name:gsub("^%l", string.upper)
        end
        -- Put <file_name> & <selected_page> at current position (=nvim_put)
        local format_string = opts.format_string .. opts.format_string_append
        local link = opts.prepend_to_link .. selected_page[1]
        -- Some link schemes like Wiki, Orgmode or AsciiDoc expect the URL to come first
        if opts.url_first then
          vim.api.nvim_put({ string.format(format_string, link, file_name) }, "", false, true)
        else -- Description first
          vim.api.nvim_put({ string.format(format_string, file_name, link) }, "", false, true)
        end
      end)
      return true
    end,
  })
end

return M
