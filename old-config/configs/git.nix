{ config, pkgs, ... }:

{
  home = {
    file.".gitignore".source = ../lib/gitignore;
    file.".gitconfig.without-user".source = ../lib/gitconfig.without-user;
    file.".gitmessage".source = ../lib/gitmessage;
    packages = [ pkgs.git-absorb ];
  };
}
