{
  pkgs,
  lib,
  nvf,
  config,
  ...
}:
let
  bindKey =
    mode: key: action: opts:
    (
      {
        inherit mode key action;
        silent = true;
        noremap = true;
        unique = true;
      }
      // opts
    );

  luaFn = functionBody: ''
    function()
      ${functionBody}
    end
  '';

  bindLuaKey =
    mode: key: functionBody:
    opts@{ desc, ... }:
    (bindKey mode key (luaFn functionBody) (opts // { lua = true; }));

  nvfConfig = {
    config.vim = {
      viAlias = true;
      vimAlias = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      theme.name = "dracula";
      theme.enable = true;

      lineNumberMode = "number";

      extraPackages = with pkgs; [
        fzf
        ripgrep
      ];

      lsp = {
        enable = true;
        formatOnSave = false;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        inlayHints.enable = true;
        otter-nvim = {
          enable = true;
          setupOpts.buffers.write_to_disk = true;
        };
        trouble.enable = true;
        lspSignature.enable = true;
        nvim-docs-view.enable = false; # lags *horribly* whenever l is pressed
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        bash.enable = true;
        css.enable = true;
        lua.enable = true;
        markdown.enable = true;
        nix = {
          enable = true;
          lsp.servers = [
            "nixd"
            "nil"
          ];
        };
        ruby = {
          enable = true;
          lsp.servers = [
            "ruby-lsp" # add rails extension
            "stimulus-language-server"
          ];
        };
        typescript = {
          enable = true;
          extraDiagnostics.enable = false;
        };
      };

      statusline.lualine = {
        enable = true;
      };

      git = (import ./neovim/git.nix).git;

      treesitter = {
        context.enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          ruby
          javascript
          typescript
          markdown
          markdown_inline
          toml
          yaml
        ];
      };

      utility = {
        snacks-nvim = {
          enable = true;
          setupOpts = {
            picker = {
              enabled = true;
            };
            explorer = {
              enabled = true;
            };
          };
        };

      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      keymaps = [
        # jk/kj as escape/C-c
        (bindKey "i" "jk" "<esc>" { desc = "jk as <esc>"; })
        (bindKey "i" "kj" "<esc>" { desc = "kj as <esc>"; })
        (bindKey "c" "jk" "<C-c>" { desc = "jk as <C-c>"; })
        (bindKey "c" "kj" "<C-c>" { desc = "kj as <C-c>"; })

        # Quick save
        (bindKey "n" "<leader>f" ":update<CR>" { desc = "<leader>f quick save"; })

        # Tab switching
        (bindKey "n" "H" "gT" { desc = "H -> Tab Left"; })
        (bindKey "n" "L" "gt" { desc = "L -> Tab Right"; })

        # Exit terminal easily
        (bindKey "t" "<esc><esc>" "<C-\\><C-n>" { desc = "Exit Terminal"; })

        (bindLuaKey "n" "<C-p>" "require('snacks').picker.smart()" {
          desc = "CtrlP (via snacks smart file picker)";
        })
      ]
        ++ (import ./neovim/md-todos.nix).keymaps;

      options = {
        # Decrease delay before which-key opens
        timeoutlen = 300;
      };

      startPlugins = with pkgs.vimPlugins; [
        vim-tmux-navigator
      ];
    };
  };

  configuredNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ nvfConfig ];
  };

  cfg = config.modules.neovim;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.modules.neovim = {
    enable = mkEnableOption "Enable neovim config";
  };

  config = mkIf cfg.enable {
    home.packages = [ configuredNeovim.neovim ];
  };
}
