{ pkgs, ... }: 
  let
    me = "seandmr";
  in {
    home = {
      username = me;
      homeDirectory = "/Users/${me}";
      stateVersion = "22.11";

      imports = [
        ./configs/vim.nix
      ];

      packages = [
        pkgs.alacritty
      ];
    };
    programs.home-manager.enable = true;
  }
