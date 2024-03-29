{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.powerline-fonts
    pkgs.powerline-symbols

    pkgs.mosh

    pkgs.tmux
    pkgs.tmuxinator

    pkgs.git
    pkgs.gh

    pkgs.ripgrep
    pkgs.fzf
    pkgs.tree
    pkgs.youtube-dl

    pkgs.nix-prefetch
    pkgs.shadowenv
  ];

  home.file.".ripgreprc".source = ../lib/ripgreprc;
  home.file.".tmux.conf".source = ../lib/tmux.conf;
  home.file.".tmuxinator" = {
    source = ../lib/tmuxinator;
    recursive = true;
  };
  home.file.".kitty.conf".source = ../lib/kitty.conf;
  home.file.".aliases".source = ../lib/aliases;
  home.file.".bin" = {
    source = ../lib/bin;
    recursive = true;
  };

  # ZSH
  # TODO: consider migrating zshrc and zsh/* config to declarative definitions
  programs.zsh = {
    enable = true;
  };
  home.file.".zshrc".source = ../lib/zshrc;
  home.file.".zsh" = {
    source = ../lib/zsh;
    recursive = true;
  };
}


