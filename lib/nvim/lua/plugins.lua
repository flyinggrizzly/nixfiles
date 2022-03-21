local packer = require 'lib/packer_init'

packer.startup(function(use)
  use { 'wbthomason/packer.nvim' } -- Let packer manage itself

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
    'airblade/vim-gitgutter',
    config = function()
      require 'plugin_config/git_gutter'
    end
  }

  --use {
    --'vim-airline/vim-airline',
    --requires = {
      --'vim-airline/vim-airline-themes'
    --},
    --config = function()
      --require 'plugin_config/airline'
    --end
  --}

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
  use { 'plasticboy/vim-markdown' }
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
  use { 'Shopify/vim-sorbet', branch = 'main' }
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
  use { 'hrsh7th/nvim-compe' }
  use {
    'tami5/lspsaga.nvim',
    after = { 'nvim-lspconfig', 'nvim-compe' },
    config = function()
      require 'plugin_config/lsp'
    end
  }

end)
