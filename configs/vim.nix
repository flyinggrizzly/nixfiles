{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Conflicts with dev-managed Ruby and Gem paths
    withRuby = false;

    extraConfig = ''
      source $HOME/.config/nvim/base_init.lua
    '';
  };


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
