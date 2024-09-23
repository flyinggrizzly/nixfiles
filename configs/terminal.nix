{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.powerline-fonts
    pkgs.powerline-symbols

    pkgs.mosh

    pkgs.tmux
    pkgs.tmuxinator

    pkgs.git
    pkgs.gh

    pkgs.wget
    pkgs.ripgrep
    pkgs.fd
    pkgs.fzf
    pkgs.tree
    pkgs.yt-dlp

    pkgs.nix-prefetch
    pkgs.nix-search-cli
  ];

  home.file.".ripgreprc".source = ../lib/ripgreprc;
  home.file.".tmux.conf".source = ../lib/tmux.conf;
  home.file.".tmuxinator" = {
    source = ../lib/tmuxinator;
    recursive = true;
  };
  home.file.".aliases".source = ../lib/aliases;
  home.file.".bin" = {
    source = ../lib/bin;
    recursive = true;
  };

  programs.zsh = {
    enable = true;
  };
  home.file.".zshrc".source = ../lib/zshrc;
  home.file.".zshrc.extend".source = ../lib/zshrc.extend;
  home.file.".zsh" = {
    source = ../lib/zsh;
    recursive = true;
  };
}
