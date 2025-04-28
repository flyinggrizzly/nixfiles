# Complete standalone home configuration as flake input
{
  description = "Test consumer for nixfiles - complete standalone";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixfiles.url = "path:../..";
    home-manager.follows = "nixfiles/home-manager";
  };

  outputs = { self, nixpkgs, nixfiles }: {
    homeConfigurations."tester@host" = nixfiles.lib.standaloneHome {
      username = "tester";
      stateVersion = "24.11";
      platform = "x86_64-linux";

      shell.zshrc = {
        sourceExtension = null;
        append = ''
          # Test appended zsh configuration
          export TEST_VAR="test_value"
          alias test-alias='echo "This is a test"'
        '';
      };

      neovim = {
        enable = true;
        enableLlmTools = true;
        extraPlugins = [];
        extraPackages = [];
        extraConfig = ''
          vim.opt.colorcolumn = "80"
        '';
        llmLuaOverride = ../lib/nvim/llm_lua_override.lua;
      };

      git = {
        enable = true;
        username = "Tester User";
        email = "tester@example.com";
        extraConfig = {
          pull.rebase = true;
          init.defaultBranch = "main";
          core.editor = "vim";
        };
      };

      desktop.enable = true;
      darwin.enable = false;

      excludePackages = [
        nixpkgs.legacyPackages.x86_64-linux.ripgrep
      ];

      extraModules = [
        ({ config, lib, pkgs, ... }: {
          home.packages = [ pkgs.ripgrep ];
          home.sessionVariables = {
            EDITOR = "nvim";
          };
          programs.starship.enable = true;
        })
      ];
    };
  };
}