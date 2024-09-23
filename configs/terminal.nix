{ lib, pkgs, ... }:

let
  kitty_symbol_map =
    "U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+ed00-U+efc1,U+f000-U+f2ff,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f533,U+f0001-U+f1af0";
  jetbrains_mono_pkg = pkgs.jetbrains-mono;
  jetbrains_mono_name = "JetBrains Mono";
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

    pkgs.nix-prefetch
    pkgs.nix-search-cli

    jetbrains_mono_pkg
    pkgs.alacritty
    pkgs.kitty-themes

    # Overrides by font: https://github.com/NixOS/nixpkgs/blob/8764d898c4f365d98ef77af140b32c6396eb4e02/pkgs/data/fonts/nerdfonts/shas.nix
    (pkgs.nerdfonts.override { fonts = [ nerdfont_jetbrains_mono_pkg nerdfont_symbols_only_pkg ]; })
  ];

  # TODO: try nerdfots and kitty config: https://discourse.nixos.org/t/setting-up-console-font-nerdfonts/37817/2
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ jetbrains_mono_name ];

  programs.kitty = {
    enable = true;
    font = {
      name = jetbrains_mono_name;
      size = 14;
      package = pkgs.jetbrains-mono;
    };
    themeFile = "Afterglow";
    settings = {
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
      # See https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
    };
    extraConfig = ''
      symbol_map U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d4,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f532,U+f0001-U+f1af0 Symbols Nerd Font Mono
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14;
        normal = {
          family = nerdfont_jetbrains_mono_name;
          style = "Regular";
        };
      };
    };
  };

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
