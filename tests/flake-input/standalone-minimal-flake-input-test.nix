# Minimal standalone home configuration as flake input
{
  description = "Test consumer for nixfiles - minimal standalone";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixfiles.url = "path:../..";
    home-manager.follows = "nixfiles/home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixfiles,
    }:
    {
      homeConfigurations."tester@host" = nixfiles.lib.standaloneHome {
        username = "tester";
        stateVersion = "24.11";
        platform = "x86_64-linux";

        neovim.enable = false;
        git.enable = false;
        desktop.enable = false;
        darwin.enable = false;
      };
    };
}
