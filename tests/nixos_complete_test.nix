# tests/nixos_complete_test.nix
#
# Test NixOS integration with complete configuration

{ pkgs, lib, getPlatformPkgs, createDerivation }:

createDerivation {
  name = "nixos-complete";
  config = lib.nixosHome {
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
      llmLuaOverride = null;
    };

    # Git configuration
    git = {
      enable = true;
      username = "Tester User";
      email = "tester@example.com";
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    # Desktop configuration
    desktop.enable = true;

    # Darwin configuration (disabled for Linux)
    darwin.enable = false;

    # Home extensions
    homeExtensions = {
      packages = [];
      sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}