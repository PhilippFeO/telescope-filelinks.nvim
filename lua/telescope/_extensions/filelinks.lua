return require("telescope").register_extension {
  exports = {
    make_filelink = require("filelinks").make_filelink,
    setup = require("filelinks").setup,
  },
}
