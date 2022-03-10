{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "seandmr";
  home.homeDirectory = "/Users/seandmr";

  imports = [
    ../configs/terminal.nix
    ../configs/git.nix
    ../configs/vim.nix
  ];

  home.file.".Brewfile".source = ../lib/Brewfile.shopify;

  # Karabiner config (OSX only)
  home.file.".config/karabiner" = {
    source = ../lib/karabiner;
    recursive = true;
  };
}

