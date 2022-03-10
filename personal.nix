{ config, pkgs, ... }:

{
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

