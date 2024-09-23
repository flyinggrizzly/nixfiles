{ pkgs, ... }:

let
  jet_brains = "JetBrainsMono";
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

    pkgs.nix-prefetch
    pkgs.nix-search-cli

    pkgs.alacritty
    pkgs.kitty-themes
  ];

  # TODO: try nerdfots and kitty config: https://discourse.nixos.org/t/setting-up-console-font-nerdfonts/37817/2
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ jet_brains ];
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
      package = (pkgs.nerdfonts.override { fonts = [ jet_brains ]; });
    };
    themeFile = "Afterglow";
    settings = {
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
    };
  };

  home.file.".ripgreprc".source = ../lib/ripgreprc;
  home.file.".tmux.conf".source = ../lib/tmux.conf;
  home.file.".tmuxinator" = {
    source = ../lib/tmuxinator;
    recursive = true;
  };
  #home.file.".kitty.conf".source = ../lib/kitty.conf;
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
