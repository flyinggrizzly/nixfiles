{ config, pkgs, lib, ... }:

let
  identifier_mapping = {
    "shopify"  = [ ./shopify.nix ];
    "personal" = [ ./personal.nix ];
  };

  # If the file is edited by hand, many editors leave a newline.
  raw_identifier = builtins.readFile ~/.machine-identifier;
  identifier = lib.removeSuffix "\n" raw_identifier;
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "seandmr";
  home.homeDirectory = "/Users/seandmr";

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

  imports = builtins.getAttr identifier identifier_mapping;
}
