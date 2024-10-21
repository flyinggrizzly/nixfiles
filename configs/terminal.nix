{ lib, pkgs, ... }:
let
  jetbrains_mono_pkg = pkgs.jetbrains-mono;
  nerdfont_jetbrains_mono_pkg = "JetBrainsMono";
  nerdfont_jetbrains_mono_name = "JetBrains Mono Nerd Font";
  nerdfont_symbols_only_pkg = "NerdFontsSymbolsOnly";
  nerdfont_symbols_only_name = "Symbols Nerd Font";
in
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

    pkgs.libyaml

    pkgs.nix-prefetch
    pkgs.nix-search-cli

    jetbrains_mono_pkg
    (pkgs.nerdfonts.override { fonts = [ nerdfont_jetbrains_mono_pkg nerdfont_symbols_only_pkg ]; })

    pkgs.graphite-cli
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

  home.file.".scripts" ={
    source = ../lib/scripts;
    recursive = true;
  };
  home.file.".zshrc".source = ../lib/zshrc;
  home.file.".zshrc.extend".source = ../lib/zshrc.extend;
  home.file.".zsh" = {
    source = ../lib/zsh;
    recursive = true;
  };
}
