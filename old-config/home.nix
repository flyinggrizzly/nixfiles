{ config, pkgs, lib, ... }:

let
  profiles_mapping = {
    "shopify"  = [ ./profiles/shopify.nix ];
    "personal" = [ ./profiles/personal.nix ];
  };

  # If the file is edited by hand, many editors leave a newline.
  raw_identifier = builtins.readFile ~/.machine-identifier;
  identifier = lib.removeSuffix "\n" raw_identifier;
in {

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  imports = builtins.getAttr identifier profiles_mapping;
}
