{ pkgs, ... }:

{
  home.packages = [
    pkgs.logseq
    pkgs.google-chrome
  ];

  programs = {
    vscode.enable = true;
  };
}
