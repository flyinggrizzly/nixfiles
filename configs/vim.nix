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

  vim-mdx-js = pkgs.vimUtils.buildVimPlugin {
    name = "vim-mdx-js";
    src = pkgs.fetchFromGitHub {
      owner = "nake89";
      repo = "vim-mdx-js";
      rev = "e578775a0be4de62091b1e34719bc788e222489d";
      sha256 = "sha256-/ADzScsG0u6RJbEtfO23Gup2NYdhPkExqqOPVcQa7aQ=";
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

  vim-zoom = pkgs.vimUtils.buildVimPlugin {
    name = "vim-zoom";
    src = pkgs.fetchFromGitHub {
      owner = "dhruvasagar";
      repo = "vim-zoom";
      rev = "01c737005312c09e0449d6518decf8cedfee32c7";
      sha256 = "sha256-/ADzScsG0u6RJbEtfO23Gup2NYdhPkExqqOPVcQa7aQ=";
    };
  };
in
{
  home.packages = [
    pkgs.nixd
  ];

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
      tokyonight-nvim

      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      #lspsaga-nvim
      nvim-treesitter.withAllGrammars
      mason-tool-installer-nvim
      fidget-nvim
      nvim-cmp
      cmp-nvim-lsp

      # TODO: investigate adding:
      # https://github.com/aznhe21/actions-preview.nvim

      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      which-key-nvim

      vim-fugitive
      gitsigns

      nvim-autopairs
      vim-commentary
      vim-easy-align
      vim-easymotion
      vim-endwise
      vim-eunuch # Adds :Rename, :SudoWrite
      fzf-vim
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
      tcomment_vim
      vim-test
      tmux-complete-vim
      tslime-vim
      yescapsquit-vim
      vim-zoom

      # Languages
      emmet-vim
      vim-haml
      vim-javascript
      vim-json
      vim-mdx-js
      vim-nix
      vim-rails
      vim-ruby
      sorbet-vim

      vim-dispatch

      vim-tmux-navigator
      tmuxline-vim

      # TODO: what do I get from these/figure out why they don't work
      vim-heritage # Automatically create parent dirs when saving... but isn't working?
      vim-sleuth
      vim-sneak
      vim-unimpaired
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
