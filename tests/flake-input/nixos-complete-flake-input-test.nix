# Complete NixOS configuration as flake input
{
  description = "Test consumer for nixfiles - complete nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixfiles.url = "path:../..";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixfiles,
      home-manager,
    }:
    {
      nixosConfigurations."test-host" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            users.users.tester = {
              isNormalUser = true;
              home = "/home/tester";
            };
          }
          nixfiles.nixosModules.home-manager
          {
            home-manager.users.tester = nixfiles.lib.nixosHome {
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
                extraPlugins = [ ];
                extraPackages = [ ];
                extraConfig = ''
                  vim.opt.colorcolumn = "80"
                '';
                llmLuaOverride = null;
              };

              git = {
                enable = true;
                username = "Tester User";
                email = "tester@example.com";
                extraConfig = {
                  pull.rebase = true;
                  init.defaultBranch = "main";
                };
              };

              desktop.enable = true;
              darwin.enable = false;

              extraModules = [
                (
                  {
                    config,
                    lib,
                    pkgs,
                    ...
                  }:
                  {
                    home.packages = [ pkgs.ripgrep ];
                    home.sessionVariables = {
                      EDITOR = "nvim";
                    };
                    programs.starship.enable = true;
                  }
                )
              ];
            };
          }
        ];
      };
    };
}
