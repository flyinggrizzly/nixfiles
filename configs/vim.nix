{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.neovim
  ];

  # VIM config
  home.file.".config/nvim" = {
    source = ../lib/nvim;
    recursive = true;
  };
  home.file.".vim-spell" = {
    source = ../lib/vim-spell;
    recursive = true;
  };
}



