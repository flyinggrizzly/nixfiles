{
  description = "A modular home-manager configuration for dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmuxinator-nix = {
      url = "github:flyinggrizzly/tmuxinator-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gwt = {
      url = "github:flyinggrizzly/gwt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      tmuxinator-nix,
      ...
    }@inputs:
    let
      # Helper function to get the appropriate pkgs for a platform
      getPkgs =
        platform:
        import nixpkgs {
          system = platform;
          config = {
            allowUnfree = true;
          };
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

      # Helper functions
      helpers = {
        claude.commandDirToTable =
          path:
          let
            files = builtins.readDir path;
            regularFiles = nixpkgs.lib.filterAttrs (name: type: type == "regular") files;
          in
          nixpkgs.lib.mapAttrs' (name: _: {
            name = nixpkgs.lib.removeSuffix ".md" name;
            value = builtins.readFile (path + "/${name}");
          }) regularFiles;
      };

      # Library functions
      lib = {
        inherit helpers;

        # Core function that creates the basic home configuration
        # This is reused by both standaloneHome and nixosHome
        prepareHome =
          {
            username,
            stateVersion,
            platform,
            shell ? { },
            neovim ? { },
            git ? { },
            desktop ? { },
            darwin ? { },
            excludePackages ? [ ],
            extraModules ? [ ],
          }:
          let
            pkgs = getPkgs platform;

            # The home-manager configuration module that both functions use
            homeConfig =
              {
                pkgs,
                ...
              }:
              {
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
                  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
                };
                programs.home-manager.enable = true;

                modules = {
                  inherit
                    shell
                    neovim
                    git
                    desktop
                    darwin
                    excludePackages
                    ;
                };
              };
          in
          {
            inherit homeConfig pkgs;
            specialArgs = {
              # This is passed to the home-manager module through extraSpecialArgs for both nixos and
              # standalone cases, so that we can access the lib.constants data in our config
              inherit tmuxinator-nix helpers;
            };
            hmModules = [
              homeConfig
              inputs.tmuxinator-nix.homeManagerModules.default
              inputs.gwt.homeManagerModules.default
            ];
          };

        # Function for standalone home-manager configuration
        standaloneHome =
          args:
          let
            prepared = lib.prepareHome args;
          in
          home-manager.lib.homeManagerConfiguration {
            pkgs = prepared.pkgs;
            modules = prepared.hmModules;
            extraSpecialArgs = prepared.specialArgs;
          };

        # Function for NixOS module integration
        nixosHome =
          args:
          let
            prepared = lib.prepareHome args;
            inherit (args) username;
          in
          {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager = {
              users.${username} =
                { config, ... }:
                {
                  imports = prepared.hmModules;
                };
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = prepared.specialArgs;
            };
          };
      };
    in
    {
      inherit lib home-manager helpers;

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

      packages = forAllSystems (
        system:
        let
          testPkgs = getPkgs system;
          tests = import ./tests {
            pkgs = testPkgs;
            inherit (self) lib;
          };
        in
        tests
      );
    };
}
