{ config, pkgs, lib, ... }:
let
  ###
  # To add new vim plugins from Github:
  #
  # 1. copy an existing block
  # 2. change the owner, repo, and rev fields
  # 3. run `% nix-git-sha OWNER REPO REV`
  # 4. set the package def's sha256 to that return value
  ###

  # Gitsigns in nixpkgs is out of date
  gitsigns = pkgs.vimUtils.buildVimPlugin {
    name = "gitsigns";
    src = pkgs.fetchFromGitHub {
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "1ef74b546732f185d0f806860fa5404df7614f28";
      sha256 = "sha256-s3y8ZuLV00GIhizcK/zqsJOTKecql7Xn3LGYmH7NLsQ=";
    };
  };

  # Tokyonight doesn't work in Spin from nixpkgs
  tokyonight = pkgs.vimUtils.buildVimPlugin {
    name = "tokyonight";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "tokyonight.nvim";
      rev = "817bb6ffff1b9ce72cdd45d9fcfa8c9cd1ad3839";
      sha256 = "sha256-d0izq6GCa5XWigiQMY3ODrdJ3jV8Lw8KCTADQA6GbXc=";
    };
  };

  sorbet-vim = pkgs.vimUtils.buildVimPlugin {
    name = "sorbet-vim";
    src = pkgs.fetchFromGitHub {
      owner = "zackhsi";
      repo = "sorbet.vim";
      rev = "41fda1edd8d790aa23542f52bd18570cdf739ea3";
      sha256 = "sha256-FYHvIoCyFHE3wWe1VVBBsHm3eet1xDR9yKxVUboaK8g=";
    };
  };

  vim-heritage = pkgs.vimUtils.buildVimPlugin {
    name = "vim-heritage";
    src = pkgs.fetchFromGitHub {
      owner = "jessarcher";
      repo = "vim-heritage";
      rev = "cffa05c78c0991c998adc4504d761b3068547db6";
      sha256 = "sha256-Lebe5V1XFxn4kSZ+ImZ69Vst9Nbc0N7eA9IzOCijFS0=";
    };
  };

  vim-haml = pkgs.vimUtils.buildVimPlugin {
    name = "vim-haml";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-haml";
      rev = "95a095a4d29eaf0ba0851dcee5635053ec0f9f74";
      sha256 = "sha256-EebHAK/YMVzt1fiROVjBiuukRZLQgaCNNHqV2DBC3U4=";
    };
  };

  vim-run-interactive = pkgs.vimUtils.buildVimPlugin {
    name = "vim-run-interactive";
    src = pkgs.fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-run-interactive";
      sha256 = "sha256-Dar5OOLRXutTHCIiDDjUEX0C3QnPWpDEnjnNcTctHUI=";
      rev = "6ae33c719bdf185325c3c1836978bb4352157c82";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    # Conflicts with dev-managed Ruby and Gem paths
    withRuby = false;

    # plugins: https://search.nixos.org/packages?from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    # more plugins: https://github.com/m15a/nixpkgs-vim-extra-plugins
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-web-devicons # required for lualine, telescope

      # Colorscheme
      #dracula-nvim
      tokyonight
      twilight-nvim

      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      mason-tool-installer-nvim
      fidget-nvim
      nvim-cmp
      cmp-nvim-lsp
      conform-nvim
      cmp-buffer
      cmp-tmux
      cmp-path
      mini-nvim # currently just for notify

      # TODO: investigate adding:
      # https://github.com/aznhe21/actions-preview.nvim

      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      which-key-nvim
      trouble-nvim

      vim-fugitive
      gitsigns

      nvim-autopairs
      vim-easy-align
      vim-endwise
      vim-eunuch # Adds :Rename, :SudoWrite
      incsearch-vim
      indent-blankline-nvim
      nerdtree
      nerdtree-git-plugin
      mkdir-nvim
      nerdcommenter
      vim-projectionist
      vim-repeat
      vim-run-interactive
      supertab
      vim-surround
      vim-test
      tmux-complete-vim
      tslime-vim
      yescapsquit-vim

      # Languages
      emmet-vim
      vim-haml
      vim-javascript
      vim-json
      vim-nix
      vim-rails
      vim-ruby
      sorbet-vim

      vim-dispatch

      vim-tmux-navigator
      tmuxline-vim

      # Automatically creates missing directories when writing a file
      vim-heritage

      # Adjusts tabstop and tabwidth intelligently
      vim-sleuth

      # Use `s${search_pattern}` to jump to the next instance of `search_pattern`
      vim-sneak

      # Nice navigation options
      vim-unimpaired
    ];

    extraPackages = with pkgs; [
      typescript-language-server
      rubyPackages.sorbet-runtime
      nixd
      lua-language-server
      vscode-langservers-extracted
    ];

    extraConfig = ''
      source $HOME/.config/nvim/base_init.lua
    '';
  };

  # VIM config
  home.file.".config/nvim" = {
    source = ../lib/nvim;
    recursive = true;
  };
  home.file.".vim-spell" = {
    source = ../lib/vim-spell;
    recursive = true;
  };
}
