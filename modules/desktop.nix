{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  jetbrains_mono_name = "JetBrains Mono";
  cfg = config.modules.desktop;

  addIf = condition: package: if condition then (lib.toList package) else []; 
in {
  options.modules.desktop = {
    enable = mkEnableOption "Enable desktop applications and configuration";
    ghostty.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Ghostty terminal configuration";
    };
    vscode.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable VSCode configuration";
    };
    firefox.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Firefox configuration";
    };
    kitty.enable = lib.mkEnableOption "Enable Kitty terminal configuration";
    slack.enable = lib.mkEnableOption "Enable Slack configuration";
    discord.enable = lib.mkEnableOption "Enable Discord configuration";
    transmission.enable = lib.mkEnableOption "Enable Transmission configuration";
  };

  config = mkIf cfg.enable {
    # Common desktop packages for all platforms
    home.packages = with pkgs; [
      logseq
      google-chrome
      code-cursor
    ] ++ (addIf cfg.kitty.enable kitty-themes)
      ++ (addIf cfg.slack.enable slack)
      ++ (addIf cfg.transmission.enable transmission)
      ++ (addIf cfg.discord.enable discord);

    # Kitty terminal
    programs.kitty = mkIf cfg.kitty.enable {
      enable = true;
      font = {
        name = jetbrains_mono_name;
        size = 14;
      };
      themeFile = "Afterglow";
      settings = {
        cursor_blink_interval = 0;
        enable_audio_bell = "no";
      };
      extraConfig = ''
        # https://github.com/ryanoasis/gerd-fonts/wiki/Glyph-Sets-and-Code-Points
        symbol_map U+E5FA-U+E62B Symbols Nerd Font Mono
        # Devicons
        symbol_map U+e700-U+e7c5 Symbols Nerd Font Mono
        # Font Awesome
        symbol_map U+f000-U+f2e0 Symbols Nerd Font Mono
        # Font Awesome Extension
        symbol_map U+e200-U+e2a9 Symbols Nerd Font Mono
        # Material Design Icons
        symbol_map U+f0001-U+f1af0 Symbols Nerd Font Mono
        # Weather
        symbol_map U+e300-U+e3e3 Symbols Nerd Font Mono
        # Octicons
        symbol_map U+f400-U+f532 Symbols Nerd Font Mono
        symbol_map U+2665 Symbols Nerd Font Mono
        symbol_map U+26A1 Symbols Nerd Font Mono
        # [Powerline Symbols]
        symbol_map U+e0a0-U+e0a2 Symbols Nerd Font Mono
        symbol_map U+e0b0-U+e0b3 Symbols Nerd Font Mono
        # Powerline Extra Symbols
        symbol_map U+e0b4-U+e0c8 Symbols Nerd Font Mono
        symbol_map U+e0cc-U+e0d4 Symbols Nerd Font Mono
        symbol_map U+e0a3 Symbols Nerd Font Mono
        symbol_map U+e0ca Symbols Nerd Font Mono
        # IEC Power Symbols
        symbol_map U+23fb-U+23fe Symbols Nerd Font Mono
        symbol_map U+2b58 Symbols Nerd Font Mono
        # Font Logos (Formerly Font Linux)
        symbol_map U+f300-U+f32f Symbols Nerd Font Mono
        # Pomicons
        symbol_map U+e000-U+e00a Symbols Nerd Font Mono
        # Codicons
        symbol_map U+ea60-U+ebeb Symbols Nerd Font Mono
        # Heavy Angle Brackets
        symbol_map U+276c-U+2771 Symbols Nerd Font Mono
        # Box Drawing
        symbol_map U+2500-U+259f Symbols Nerd Font Mono
      '';
    };

    # Ghostty terminal
    programs.ghostty = mkIf cfg.ghostty.enable {
      enable = true;
      installVimSyntax = true;
      settings = {
        theme = "calamity";
        cursor-style = "underline";
        font-family = "JetBrains Mono";
        keybind = [
          "alt+right=unbind"
          "alt+left=unbind"
        ];
      };
    };

    programs.firefox = mkIf cfg.firefox.enable {
      enable = true;
      languagePacks = [ "en-US" ];
      policies = {
        "AppAutoUpdate" = false;
        "DisableTelemetry" = true;
        "OfferToSaveLogins" = false;
        "PromptForDownloadLocation" = true;
      };
    };

    # VSCode
    programs.vscode = mkIf cfg.vscode.enable {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          asvetliakov.vscode-neovim
          bierner.markdown-mermaid
        ];
        userSettings = {
          "vscode-neovim.compositeKeys" = {
            "jk" = {
              "command" = "vscode-neovim.escape";
            };
            "kj" = {
              "command" = "vscode-neovim.escape";
            };
          };

          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };
        };
      };
    };
  };
}
