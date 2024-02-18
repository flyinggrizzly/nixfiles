{ config, pkgs, ... }: {
  home.file.".Brewfile".source = ../lib/Brewfile;
}
