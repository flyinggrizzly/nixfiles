# Minimal NixOS configuration as flake input
{
  description = "Test consumer for nixfiles - minimal nixos";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixfiles.url = "path:../..";
    home-manager.url = "github:nix-community/home-manager";
  };
  
  outputs = { self, nixpkgs, nixfiles, home-manager }: {
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
            
            neovim.enable = false;
            git.enable = false;
            desktop.enable = false;
            darwin.enable = false;
          };
        }
      ];
    };
  };
}