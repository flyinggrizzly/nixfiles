# tests/standalone_complete_test.nix
#
# Test for standalone home with full configuration

{ pkgs, lib, getPlatformPkgs, createDerivation }:

createDerivation {
  name = "standalone-complete";
  config = lib.standaloneHome {
    username = "tester";
    stateVersion = "24.11";
    platform = "x86_64-linux";

    # Shell configuration
    shell.extendZshConfig = null;

    # Neovim configuration
    neovim = {
      enable = true;
      enableLlmTools = true;
      extraPlugins = [];
      extraPackages = [];
      extraConfig = ''
        vim.opt.colorcolumn = "80"
      '';
      llmLuaOverride = ./lib/nvim/llm_lua_override.lua;
    };

    # Git configuration
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

    # Desktop configuration
    desktop.enable = true;

    # Darwin configuration (disabled for Linux)
    darwin = {
      enable = false;
    };

    excludePackages = [
      pkgs.ripgrep
    ];

    # Direct configuration through extraModules
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
}