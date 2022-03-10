{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "seandmr";
  home.homeDirectory = "/Users/seandmr";

  imports = [
    ./terminal.nix
    ./git.nix
    ./vim.nix
  ];

  home.packages = [
    pkgs.alacritty
  ];

  home.file.".gitconfig".source = ./lib/gitconfig;

  home.file.".Brewfile".source = ./lib/Brewfile.personal;

  # Karabiner config (OSX only)
  home.file.".config/karabiner" = {
    source = ./lib/karabiner;
    recursive = true;
  };
}

