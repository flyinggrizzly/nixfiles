{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.neovim
  ];

  # VIM config
  home.file.".vim" = {
    source = ./lib/vim;
    recursive = true;
  };
  home.file.".config/nvim/init.vim".source = ./lib/nvim/init.vim;
  home.file.".vimrc".source = ./lib/vimrc;
  home.file.".vimrc.bundles".source = ./lib/vimrc.bundles;
  home.file.".vim-spell" = {
    source = ./lib/vim-spell;
    recursive = true;
  };
}



