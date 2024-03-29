{ pkgs, ... }:
  let
    me = "seandmr";
    host = "m1-grizzly";
  in {
    home = {
      username = me;
      homeDirectory = "/Users/${me}";
      stateVersion = "22.11";

      file.".machine-identifier".text = host;

      packages = [
        pkgs.alacritty
      ];

      file = {
        "Library/Application Support/Alfred/Alfred.alfredpreferences" = {
          source = ./lib/Alfred.alfredpreferences;
          recursive = true;
        };
        "Library/Application Support/Alfred/prefs.json".source = ./lib/alfred-prefs.json;
      };

      # Karabiner config (OSX only)
      file.".config/karabiner" = {
        source = ./lib/karabiner;
        recursive = true;
      };
    };

    imports = [
      ./configs/git.nix
      ./configs/terminal.nix
      ./configs/vim.nix
      ./configs/brew.nix
    ];

    programs.home-manager.enable = true;
  }
