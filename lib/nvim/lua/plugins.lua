local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end


local in_shopify = function()
  local machine_identifier_f = io.popen('machine-identifier')
  local machine_identifier = machine_identifier_f:read('*a')
  machine_identifier_f:close()

  return machine_identifier == 'shopify'
end

return require('packer').startup(function(use)
  -- My plugins here
  use { 'wbthomason/packer.nvim' } -- Let packer manage itself

  use {
    'Shopify/shadowenv.vim',
    cond = { in_shopify }
  }
  use {
    'Shopify/vim-sorbet',
    cond = { in_shopify }
  }

  use { 'christoomey/vim-tmux-navigator' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-eunuch' } -- Adds :Rename, :SudoWrite
  use { 'tpope/vim-unimpaired' } -- Adds [b and other handy mappings
  use { 'tpope/vim-sleuth' } -- Indent autodetection with editorconfig support
  use { 'jessarcher/vim-heritage' } -- Automatically create parent dirs when saving

  use { 'tpope/vim-projectionist' }

  use {
    'rakr/vim-one',
    config = function()
      require 'plugin_config/colorscheme'
    end
  }
  use {
    'airblade/vim-gitgutter',
    config = function()
      require 'plugin_config/git_gutter'
    end
  }

  use {
    'vim-airline/vim-airline',
    requires = {
      'vim-airline/vim-airline-themes'
    },
    config = function()
      require 'plugin_config/airline'
    end
  }
  use {
    'edkolev/tmuxline.vim',
    config = function()
      require 'plugin_config/tmuxline'
    end
  }
  use { 'lukas-reineke/indent-blankline.nvim' }

  use { 'tpope/vim-endwise' }
  use { 'vim-scripts/tComment' }
  use { 'pbrisbin/vim-mkdir' }

  use { 'tpope/vim-dispatch' }
  use { 'jiangmiao/auto-pairs' } --- Auto-complete closing brackets
  use { 'scrooloose/nerdcommenter' }
  use { 'ervandew/supertab' }
  use { 'easymotion/vim-easymotion' }
  use { 'wikitopian/hardmode' }
  use { 'godlygeek/tabular' }
  use { 'elzr/vim-json' }
  use { 'junegunn/vim-easy-align' }
  use { 'christoomey/vim-run-interactive' }

  use {
    'junegunn/fzf',
    run = function()
      vim.fun['fzf#install']()
    end
  }

  use {
    'junegunn/fzf.vim',
    after = 'fzf',
    config = function()
      require 'plugin_config/fzf'
    end
  }

  use { 'tpope/vim-fugitive' }

  use {
    'scrooloose/nerdtree',
    requires = {
      'Xuyuanp/nerdtree-git-plugin'
    },
    config = function()
      require 'plugin_config/nerdtree'
    end
  }

  use { 'dhruvasagar/vim-zoom' }
  use { 'haya14busa/incsearch.vim' }
  use { 'wellle/tmux-complete.vim' }
  use { 'janko-m/vim-test' }
  use { 'pangloss/vim-javascript' }
  use { 'jxnblk/vim-mdx-js' }
  use { 'leafgarland/typescript-vim' }

  use {
    'mattn/emmet-vim',
    config = function()
      require 'plugin_config/emmet'
    end
  }
  use { 'tpope/vim-rails' }
  use { 'tpope/vim-rake' }
  use { 'vim-ruby/vim-ruby' }
  use { 'zackhsi/sorbet.vim' }
  use { 'tpope/vim-bundler' }
  use { 'ngmy/vim-rubocop' }
  use { 'tpope/vim-haml' }
  use {
    'jgdavey/tslime.vim',
    config = function()
      require 'plugin_config/tslime'
    end
  }
  use { 'LnL7/vim-nix' }

  use { 'dracula/vim', as = 'dracula' }
  use { 'neovim/nvim-lspconfig' }
  use { 'williamboman/nvim-lsp-installer' }
  use {
    'tami5/lspsaga.nvim',
    branch = 'nvim6.0',
    after = { 'nvim-lspconfig' },
    config = function()
      require 'plugin_config/lsp'
    end
  }
  use { 'weilbith/nvim-code-action-menu' }

  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end ,
    config = function()
      require 'plugin_config/firenvim'
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
