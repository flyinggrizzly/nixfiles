{
  pkgs,
  nvf,
  ...
}:
let
  luaMap =
    key: action:
    opts@{ mode ? "n",
      ...
    }:
    {
      inherit key action mode;
      lua = true;
    }
    // opts;

  nvfConfig = {
    vim = {
      viAlias = true;
      vimAlias = true;

      theme.name = "dracula";

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

      keymaps = [
        (luaMap "<C-p>" ''
          function()
            require('snacks').picker.smart()
          end
        '')
      ];
    };
  };

  configuredNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;

    modules = [ nvfConfig ];
  };
in
{
  config = {
    home.packages = [ configuredNeovim.neovim ];
  };
}
