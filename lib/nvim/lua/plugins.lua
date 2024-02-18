-- Support for conditional installs
local in_shopify = function()
  local machine_identifier_f = io.popen('machine-identifier')
  local machine_identifier = machine_identifier_f:read('*a')
  machine_identifier_f:close()

  return machine_identifier == 'shopify'
end

return {
  {
    "Shopify/shadowenv.vim",
    cond = function()
      return in_shopify()
    end
  },
  {
    "Shopify/vim-sorbet",
    cond = function()
      return in_shopify()
    end
  },
  "christoomey/vim-tmux-navigator",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-eunuch", -- Adds :Rename, :SudoWrite
  "tpope/vim-unimpaired", -- Adds [b and other handy mappings
  "tpope/vim-sleuth", -- Indent autodetection with editorconfig support
  "jessarcher/vim-heritage", -- Automatically create parent dirs when saving
  "tpope/vim-projectionist",

  require 'colorscheme',

  {
    "airblade/vim-gitgutter",
    config = function()
      require 'plugin_config/git_gutter'
    end
  },
  {
    "vim-airline/vim-airline",
    dependencies = {
      'vim-airline/vim-airline-themes'
    },
    config = function()
      require 'plugin_config/airline'
    end
  },
  {
    'edkolev/tmuxline.vim',
    config = function()
      require 'plugin_config/tmuxline'
    end
  },
  'lukas-reineke/indent-blankline.nvim',

  'tpope/vim-endwise',
  'vim-scripts/tComment',
  'pbrisbin/vim-mkdir',

  'tpope/vim-dispatch',
  'jiangmiao/auto-pairs', --- Auto-complete closing brackets
  'scrooloose/nerdcommenter',
  'ervandew/supertab',
  'easymotion/vim-easymotion',
  'wikitopian/hardmode',
  'godlygeek/tabular',
  'elzr/vim-json',
  'junegunn/vim-easy-align',
  'christoomey/vim-run-interactive',

  {
    'junegunn/fzf',
    build = function()
      vim.fun['fzf#install']()
    end
  },

  {
    'junegunn/fzf.vim',
    config = function()
      require 'plugin_config/fzf'
    end,
  },
  'tpope/vim-fugitive',
  {
    'scrooloose/nerdtree',
    dependencies = {
      'Xuyuanp/nerdtree-git-plugin'
    },
    config = function()
      require 'plugin_config/nerdtree'
    end
  },

  'dhruvasagar/vim-zoom',
  'haya14busa/incsearch.vim',
  'wellle/tmux-complete.vim',
  'janko-m/vim-test',
  'pangloss/vim-javascript',
  'jxnblk/vim-mdx-js',
  'leafgarland/typescript-vim',

  {
    'mattn/emmet-vim',
    config = function()
      require 'plugin_config/emmet'
    end
  },
  'tpope/vim-rails',
  'tpope/vim-rake',
  'vim-ruby/vim-ruby',
  'zackhsi/sorbet.vim',
  'tpope/vim-bundler',
  'ngmy/vim-rubocop',
  'tpope/vim-haml',
  {
    'jgdavey/tslime.vim',
    config = function()
      require 'plugin_config/tslime'
    end
  },
  'LnL7/vim-nix',

  'neovim/nvim-lspconfig',
  'williamboman/nvim-lsp-installer',
  {
    'nvimdev/lspsaga.nvim',
    dependencies = { 'nvim-lspconfig' },
    config = function()
      require 'plugin_config/lsp'
    end
  },
  'weilbith/nvim-code-action-menu',
}
