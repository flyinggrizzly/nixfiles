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
    };

    imports = [
      ./configs/git.nix
      ./configs/vim.nix
      ./configs/terminal.nix
    ];

    programs.home-manager.enable = true;
  }
