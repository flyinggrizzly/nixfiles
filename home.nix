{ pkgs, ... }: 
  let
    me = "seandmr";
  in {
    home = {
      username = me;
      homeDirectory = "/Users/${me}";
      stateVersion = "22.11";


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
    };

    imports = [
      ./configs/git.nix
      ./configs/vim.nix
      ./configs/terminal.nix
    ];

    programs.home-manager.enable = true;
  }
