{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.modules.neovim;

  # Custom plugins
  gitsigns = pkgs.vimUtils.buildVimPlugin {
    name = "gitsigns";
    src = pkgs.fetchFromGitHub {
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "1ef74b546732f185d0f806860fa5404df7614f28";
      sha256 = "sha256-s3y8ZuLV00GIhizcK/zqsJOTKecql7Xn3LGYmH7NLsQ=";
    };
  };
  
  # Use a more stable repository for codecompanion
  #codecompanion-nvim = pkgs.vimUtils.buildVimPlugin {
    #name = "codecompanion-nvim";
    #src = pkgs.fetchFromGitHub {
      #owner = "olimorris";
      #repo = "codecompanion.nvim";
      #rev = "9654cb31f10c9eda3e777d03d32b29df606ab0fe";
      #sha256 = "sha256-NKGKfCXgwbmj+6pO0IQH3IWpH7rY9bTzLXKCGt2qxDk=";
    #};
  #};

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

  render-markdown-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "render-markdown-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "MeanderingProgrammer";
      repo = "render-markdown.nvim";
      rev = "7808306438e51d7222534759011cddedf36ce580";
      sha256 = "sha256-K2YbO4vIjVgYrWF4MVxqiaTmONF1ZvMXxZVIW/UYwRo=";
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
in {
  options.modules.neovim = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Neovim editor configuration";
    };

    enableLlmTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable LLM-related tools and plugins for Neovim";
    };

    extraPlugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional packages to install for Neovim";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional packages to install for Neovim";
    };

    extraConfig = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Additional Lua configuration for Neovim";
    };

    llmLuaOverride = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Override the default LLM configuration with custom Lua code";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;

      # Conflicts with dev-managed Ruby and Gem paths
      withRuby = false;

      plugins = with pkgs.vimPlugins; [
        # UI and themes
        lualine-nvim
        nvim-web-devicons
        dracula-nvim
        twilight-nvim

        # LSP and completion
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
        mini-nvim

        # Telescope
        telescope-nvim
        telescope-ui-select-nvim
        telescope-fzf-native-nvim
        plenary-nvim
        which-key-nvim
        trouble-nvim

        # Custom tools
        snacks-nvim
        lazygit-nvim
        oil-nvim

        # Git integration
        vim-fugitive
        gitsigns

        # Editing helpers
        nvim-autopairs
        vim-easy-align
        vim-endwise
        vim-eunuch
        incsearch-vim
        indent-blankline-nvim
        mkdir-nvim
        nerdcommenter
        vim-projectionist
        vim-repeat
        vim-run-interactive
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

        # Tmux integration
        vim-dispatch
        vim-tmux-navigator
        tmuxline-vim

        # Utilities
        vim-heritage
        vim-sleuth
        leap-nvim
        vim-unimpaired
      ] ++ (if config.modules.neovim.enableLlmTools then with pkgs.vimPlugins; [
        # AI and code assistance
        avante-nvim
        codecompanion-nvim
        copilot-lua
        copilot-cmp
        dressing-nvim
        nui-nvim
        render-markdown-nvim
      ] else []) ++ config.modules.neovim.extraPlugins;

      extraPackages = with pkgs; [
        typescript-language-server
        prettierd
        rubyPackages.sorbet-runtime
        nixd
        lua-language-server
        vscode-langservers-extracted
      ] ++ config.modules.neovim.extraPackages;

      extraConfig = ''
        source $HOME/.config/nvim/base_init.lua
      '';
    };

    # VIM config files
    home.file.".config/nvim" = {
      source = ../lib/nvim;
      recursive = true;
    };

    # Create a simple flag file that can be checked in Lua
    home.file.".config/nvim/lua/plugin_config/llms_enabled.lua" = {
      text = if config.modules.neovim.enableLlmTools then "return true" else "return false";
    };

    # Conditionally override the default llms.lua with a custom one if provided
    home.file.".config/nvim/lua/plugin_config/llms.lua" = mkIf (config.modules.neovim.llmLuaOverride != null) {
      source = config.modules.neovim.llmLuaOverride;
    };

    home.file.".vim-spell" = {
      source = ../lib/vim-spell;
      recursive = true;
    };
  };
}
