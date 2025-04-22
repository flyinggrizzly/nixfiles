# Minimal standalone home configuration for darwin as flake input
{
  description = "Test consumer for nixfiles - minimal standalone darwin";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixfiles.url = "path:../..";
    home-manager.url = "github:nix-community/home-manager";
  };
  
  outputs = { self, nixpkgs, nixfiles, home-manager }: {
    homeConfigurations."tester@darwin" = nixfiles.lib.standaloneHome {
      username = "tester";
      stateVersion = "24.11";
      platform = "aarch64-darwin";
      
      neovim.enable = false;
      git.enable = false;
      desktop.enable = false;
      darwin.enable = true;
    };
  };
}