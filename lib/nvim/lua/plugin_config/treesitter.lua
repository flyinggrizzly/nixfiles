local treesitter = require('nvim-treesitter')

treesitter.setup {}
local should_install = {
  'vim',
  'nix',
  'xml',
  'css',
  'bash',
  'diff',
  'lua',
  'luap',
  'luadoc',
  'vimdoc',
  'typescript',
  'javascript',
  'jsdoc',
  'html',
  'http',
  'json',
  'sql',
  'ruby',
  'csv',
  'gitignore',
  'gitcommit',
  'gitattributes',
  'git_config',
  'rust',
  'query',
  'toml',
  'yaml',
  'regex',
  'markdown',
  'markdown_inline',
}

treesitter.install(
  require('helpers').table_except(should_install, treesitter.get_installed())
)

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if
      vim.list_contains(
        treesitter.get_installed(),
        vim.treesitter.language.get_lang(args.match)
      )
      then
        vim.treesitter.start(args.buf)
      end
    end,
  }
)

require('plugin_config/treesitter/textobjects')
