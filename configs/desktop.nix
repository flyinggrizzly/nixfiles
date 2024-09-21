{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.alacritty
    pkgs.logseq
    pkgs.google-chrome
  ];

  programs = {
    kitty.enable = true;
    vscode.enable = true;
  };
}
