{ config, pkgs, ... }:

{
  home.file.".gitignore".source = ./lib/gitignore;
  home.file.".gitconfig.without-user".source = ./lib/gitconfig.without-user;
  home.file.".gitmessage".source = ./lib/gitmessage;
}

