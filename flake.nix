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

      # Library functions
      lib = {
        # Core function that creates the basic home configuration
        # This is reused by both standaloneHome and nixosHome
        prepareHome = { 
          username,
          stateVersion,
          platform,
          neovim ? {},
          git ? {},
          desktop ? {},
          darwin ? {},
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
                ];
                
                # Basic home configuration
                home = {
                  inherit username stateVersion;
                  homeDirectory = if pkgs.stdenv.isDarwin 
                    then "/Users/${username}"
                    else "/home/${username}";
                };
                programs.home-manager.enable = true;
                
                # Pass only module configuration options, not global params
                modules = {
                  # Module config options only
                  inherit neovim git desktop darwin;
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
            # Return home-manager configuration
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ homeConfig ];
              # No special args needed
            };

        # Function for NixOS module integration
        nixosHome = args:
          let
            prepared = lib.prepareHome args;
            inherit (prepared) homeConfig;
            inherit (args) username;
          in {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager.users.${username} = homeConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          };
      };
    in {
      # Keep the original lib for backward compatibility
      inherit lib;

      # Templates for user configurations
      templates = {
        # The standalone template is now the default
        default = {
          path = ./templates/standalone;
          description = "Standalone home-manager configuration template";
        };
        standalone = {
          path = ./templates/standalone;
          description = "Standalone home-manager configuration template";
        };
        nixos = {
          path = ./templates/nixos;
          description = "NixOS configuration with home-manager integration";
        };
      };

      # Example configurations for specific systems
      # These could be expanded or removed as needed
      homeConfigurations = {
        "seandmr@m1-grizzly" = lib.standaloneHome {
          username = "seandmr";
          stateVersion = "24.11";
          platform = "aarch64-darwin";
          desktop.enable = true;
          darwin.enable = true;
        };
      };
    };
}
