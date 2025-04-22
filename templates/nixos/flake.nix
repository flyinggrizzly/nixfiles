{
  description = "NixOS configuration with home-manager integration using nixfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Import dotfiles flake - update this URL to your fork
    dotfiles.url = "github:seandmr/nixfiles";
    
    # Home-manager is already imported through the dotfiles flake
    home-manager.follows = "dotfiles/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }:
    let
      system = "x86_64-linux"; # Change to your system architecture
      username = "user";       # Change to your username
      hostname = "hostname";   # Change to your hostname
    in {
      # NixOS configuration
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Your main NixOS configuration
          ({ pkgs, lib, ... }: {
            # Basic system configuration
            networking.hostName = hostname;
            users.users.${username} = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
              # No need to specify packages here as they'll come from home-manager
            };
            
            # System-level packages
            environment.systemPackages = with pkgs: [
              git
              vim
              wget
            ];
            
            # Allow unfree packages (if needed)
            nixpkgs.config.allowUnfree = true;
            
            # Boot configuration, hardware, etc. would go here
            # This is just a minimal example
            
            system.stateVersion = "24.05";
          })
          
          # Import home-manager NixOS module
          dotfiles.nixosHome {
            inherit username hostname;
            systemIdentifier = system;
            stateVersion = "24.05";
            
            # Git configuration
            git = {
              enable = true;
              username = "Your Name";
              email = "your.email@example.com";
              extraConfig = {
                pull.rebase = true;
                init.defaultBranch = "main";
                core.editor = "vim";
              };
            };
            
            # Neovim configuration
            neovim = {
              enable = true;
              enableLlmTools = true;
              extraPlugins = [];
              extraPackages = [];
            };
            
            # Desktop configuration
            desktop = {
              enable = true; # Set to false for headless systems
            };
            
            # Darwin settings (disabled for NixOS)
            darwin.enable = false;
            
            # Direct configuration through extraModules
            extraModules = [
              # Custom module with direct home-manager settings
              ({ config, pkgs, ... }: {
                # Example configurations:
                # home.file.".config/custom/settings.json".text = ''{ "setting": "value" }'';
                # home.packages = [ pkgs.ripgrep ];
                # home.sessionVariables = { EDITOR = "nvim"; };
                # programs.starship.enable = true;
              })
            ];
          }
        ];
      };
    };
}