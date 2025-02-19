{
  description = "dotfiles";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { nixpkgs, home-manager, ... }: {
      # For `nix run .` later
      packages.aarch64-darwin.default = home-manager.packages.aarch64-darwin.default;

      homeConfigurations = {
        "seandmr" = home-manager.lib.homeManagerConfiguration {
          # Note: I am sure this could be done better with flake-utils or something
          pkgs = import nixpkgs { system = "aarch64-darwin"; };

          modules = [ ./home.nix ];
      };
    };
  };
}
