{
  description = "Home Manager standalone configuration using nixfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Import dotfiles flake - update this URL to your fork
    dotfiles.url = "github:seandmr/nixfiles";
  };

  outputs = { nixpkgs, home-manager, dotfiles, ... }:
    let
      system = "x86_64-linux"; # Change to your system (aarch64-darwin, x86_64-darwin, etc.)
      username = "user";       # Change to your username
      hostname = "hostname";   # Change to your hostname
    in {
      homeConfigurations."${username}@${hostname}" = dotfiles.standaloneHome {
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
            # Any other git config attributes
          };
        };

        # Neovim configuration
        neovim = {
          enable = true;
          enableLlmTools = true;
          extraPlugins = [];
          extraPackages = [];
          extraConfig = ''
            -- Your additional Lua configuration
            vim.opt.colorcolumn = "80"
          '';
          llmLuaOverride = null; # Path to custom LLM config if needed
        };

        # Desktop configuration
        desktop = {
          enable = true; # Set to false for headless systems
        };

        # macOS-specific configuration
        darwin = {
          enable = false; # Set to true for macOS systems
          brewfile = ./Brewfile; # Path to your Brewfile (if on macOS)
          alfred.enable = false;
          karabiner.enable = false;
        };
        
        # Extensions - allows extending any configuration attributes
        extensions = {
          # Example configurations:
          # home.file.".config/custom/settings.json".text = ''{ "setting": "value" }'';
          # home.packages = [ pkgs.ripgrep ];
          # home.sessionVariables = { EDITOR = "nvim"; };
          # programs.starship.enable = true;
        };
      };
    };
}