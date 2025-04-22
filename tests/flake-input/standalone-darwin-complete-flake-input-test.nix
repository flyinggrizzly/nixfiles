# Complete standalone home configuration for darwin as flake input
{
  description = "Test consumer for nixfiles - complete standalone darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixfiles.url = "path:../..";
    home-manager.follows = "nixfiles/home-manager";
  };

  outputs = { self, nixpkgs, nixfiles }: {
    homeConfigurations."tester@darwin" = nixfiles.lib.standaloneHome {
      username = "tester";
      stateVersion = "24.11";
      platform = "aarch64-darwin";

      shell.extendZshConfig = null;

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
      darwin = {
        enable = true;
        defaults = {
          NSGlobalDomain = {
            AppleKeyboardUIMode = 3;
            ApplePressAndHoldEnabled = false;
          };
          dock = {
            autohide = true;
            orientation = "bottom";
          };
        };
      };

      excludePackages = [
        nixpkgs.legacyPackages.aarch64-darwin.ripgrep
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