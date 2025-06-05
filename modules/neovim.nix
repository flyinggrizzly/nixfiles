{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.neovim;

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
      default = [ ];
      description = "Additional packages to install for Neovim";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to install for Neovim";
    };

    init.prepend = mkOption {
      type = types.str;
      default = "";
      description = "Prepend to init.lua";
    };

    init.append = mkOption {
      type = types.str;
      default = "";
      description = "Append to init.lua";
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

      plugins =
        with pkgs.vimPlugins;
        [
          # UI and themes
          lualine-nvim
          nvim-web-devicons
          dracula-nvim
          twilight-nvim

          # LSP and completion
          nvim-lspconfig
          rustaceanvim
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          mason-tool-installer-nvim
          fidget-nvim
          nvim-cmp
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-git
          cmp-emoji
          cmp-buffer
          cmp-tmux
          cmp-path
          mini-nvim
          conform-nvim

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
          gitsigns-nvim

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
          render-markdown-nvim
        ]
        ++ (
          if cfg.enableLlmTools then
            with pkgs.vimPlugins;
            [
              # AI and code assistance
              codecompanion-nvim
              copilot-lua
              copilot-cmp
              dressing-nvim
              nui-nvim
              claude-code-nvim
            ]
          else
            [ ]
        )
        ++ cfg.extraPlugins;

      extraPackages =
        with pkgs;
        [
          typescript-language-server
          prettierd
          rubyPackages.sorbet-runtime
          nixd
          rust-analyzer
          nixfmt-rfc-style
          lua-language-server
          vscode-langservers-extracted
        ]
        ++ cfg.extraPackages;

      extraConfig = ''
        ${cfg.init.prepend}

        source $HOME/.config/nvim/base_init.lua

        ${cfg.init.append}
      '';
    };

    # VIM config files
    home.file.".config/nvim" = {
      source = ../lib/nvim;
      recursive = true;
    };

    # Create a simple flag function that is imported by lua/helpers
    home.file.".config/nvim/lua/helpers/llms_enabled.lua".text =
      if cfg.enableLlmTools then
        ''
          return function ()
            return true
          end
        ''
      else
        ''
          return function ()
            return false
          end
        '';

    home.file.".config/nvim/lua/plugin_config/custom_llms.lua" =
      mkIf (cfg.llmLuaOverride != null)
        {
          source = cfg.llmLuaOverride;
        };

    home.file.".vim-spell" = {
      source = ../lib/vim-spell;
      recursive = true;
    };
  };
}
