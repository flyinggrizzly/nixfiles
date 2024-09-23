local textobjects = require('plugin_config/treesitter/textobjects')

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = {
    enable = true,
    disable = { 'ruby' },
  },
  textobjects = textobjects.map().configure(),
})
