return require("telescope").register_extension {
  -- setup = function(ext_config, config)
  --   -- access extension config and user config
  -- end,
  exports = {
    -- This key must be used when accessing the functions after
    -- loading the extension.
    make_filelink = require("filelinks").make_filelink,
    setup = require("filelinks").setup,
  },
}
