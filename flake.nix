{
  description = "A modular home-manager configuration for dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Helper function to get the appropriate pkgs for a platform
      getPkgs = platform:
        import nixpkgs {
          system = platform;
          config = { allowUnfree = true; };
        };

      # Supported systems for testing
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper to create flake outputs for each system
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Library functions
      lib = {
        # Core function that creates the basic home configuration
        # This is reused by both standaloneHome and nixosHome
        prepareHome = {
          username,
          stateVersion,
          platform,
          shell ? {},
          neovim ? {},
          git ? {},
          desktop ? {},
          darwin ? {},
          excludePackages ? [],
          extraModules ? [],
        }:
          let
            pkgs = getPkgs platform;

            # The home-manager configuration module that both functions use
            homeConfig = { config, lib, pkgs, ... }: {
              imports = [
                ./modules/neovim.nix
                ./modules/git.nix
                ./modules/shell.nix
                ./modules/desktop.nix
                ./modules/darwin.nix
                ./modules/exclude-packages.nix
              ] ++ extraModules; # Direct import of extra modules

              # Basic home configuration
              home = {
                inherit username stateVersion;
                homeDirectory = if pkgs.stdenv.isDarwin
                  then "/Users/${username}"
                else "/home/${username}";
              };
              programs.home-manager.enable = true;

              modules = {
                inherit shell neovim git desktop darwin excludePackages;
              };
            };
          in {
            inherit homeConfig pkgs;
          };

        # Function for standalone home-manager configuration
        standaloneHome = args:
          let
            prepared = lib.prepareHome args;
            inherit (prepared) homeConfig pkgs;
          in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ homeConfig ];
            };

        # Function for NixOS module integration
        nixosHome = args:
          let
            prepared = lib.prepareHome args;
            inherit (prepared) homeConfig;
            inherit (args) username;
          in {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager.users.${username} = { config, ... }: {
              imports = [ homeConfig ];
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          };
      };
    in {
      inherit lib home-manager;

      templates = {
        standalone = {
          path = ./templates/standalone;
          description = "Standalone home-manager configuration template";
        };
        nixos = {
          path = ./templates/nixos;
          description = "NixOS configuration with home-manager integration";
        };
      };

      homeConfigurations = {
        "seandmr@m1-grizzly" = lib.standaloneHome {
          username = "seandmr";
          stateVersion = "24.11";
          platform = "aarch64-darwin";
          darwin.enable = true;
          desktop = {
            enable = true;
            ghostty.enable = true;
            kitty.enable = false;
            transmission.enable = true;
          };
        };
      };

      packages = forAllSystems (system:
        let
          testPkgs = getPkgs system;
          tests = import ./tests {
            pkgs = testPkgs;
            inherit (self) lib;
          };
        in tests
      );
    };
}
