{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.tmux
    pkgs.tmuxinator

    pkgs.git
    pkgs.gh

    pkgs.ripgrep
    pkgs.tree
    pkgs.youtube-dl
  ];

  home.file.".tmux.conf".source = ../lib/tmux.conf;
  home.file.".tmuxinator" = {
    source = ../lib/tmuxinator;
    recursive = true;
  };
  home.file.".gitignore".source = ../lib/gitignore;
  home.file.".aliases".source = ../lib/aliases;
  home.file.".bin" = {
    source = ../lib/bin;
    recursive = true;
  };

  # ZSH
  home.file."._zshrc".source = ../lib/zshrc;
  home.file.".zsh" = {
    source = ../lib/zsh;
    recursive = true;
  };
}


