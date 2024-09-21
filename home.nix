{ pkgs, lib, ... }:
let
  me = "seandmr";
  host = "m1-grizzly";
in {
  options.isMac = lib.options.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = {
    home = {
      username = me;
      homeDirectory = "/Users/${me}";
      stateVersion = "22.11";

      file.".machine-identifier".text = host;

      packages = [
        pkgs.alacritty
      ];
    };

    programs.home-manager.enable = true;
  };

  imports = [
    ./configs/git.nix
    ./configs/terminal.nix
    ./configs/vim.nix
    ./configs/if_mac.nix
  ];
}
