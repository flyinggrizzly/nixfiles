{ pkgs, ... }: 
  let
    me = "seandmr";
  in {
    home = {
      username = me;
      homeDirectory = "/Users/${me}";
      stateVersion = "22.11";
    };
    programs.home-manager.enable = true;
  }
