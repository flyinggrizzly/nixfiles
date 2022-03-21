{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.powerline-fonts
    pkgs.powerline-symbols

    pkgs.tmux
    pkgs.tmuxinator

    pkgs.git
    pkgs.gh

    pkgs.ripgrep
    pkgs.fzf
    pkgs.tree
    pkgs.youtube-dl
  ];

  home.file.".tmux.conf".source = ../lib/tmux.conf;
  home.file.".tmuxinator" = {
    source = ../lib/tmuxinator;
    recursive = true;
  };
  home.file.".kitty.conf".source = ../lib/kitty.conf;
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


