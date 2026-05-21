local treesitter = require('nvim-treesitter')
local helpers = require('helpers')

treesitter.setup {}

-- In short-lived editor contexts (git commit/rebase, pi/claude agent prompt
-- edits) we skip grammar installs and the FileType auto-start. The buffer
-- closes within seconds, syntax compile is pure overhead, and the user is
-- typing prose anyway.
if helpers.is_transient_edit() then
  return
end

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
