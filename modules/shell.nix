{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.modules.shell;
  baseZshrc = builtins.readFile ../lib/zshrc;
  finalZshrc = baseZshrc + "\n# Appended ZSH configuration\n" + cfg.zshrc.append;
  addIf = condition: package: if condition then (lib.toList package) else [];
in {
  options.modules.shell = {
    zshrc = {
      sourceExtension = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Additional ZSH config file--included at end of main zshrc";
      };

      append = mkOption {
        type = types.str;
        default = "";
        description = ''
          Additional ZSH configuration to append to zshrc. Will be appended after `sourceExtension` is
          sourced if present.
        '';
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      _1password-cli

      # Core terminal utilities
      mosh
      tmux
      tmuxinator

      # Version control
      git
      gh
      lazygit
      graphite-cli

      # File and text utilities
      wget
      ripgrep
      fd
      fzf
      tree

      # Development tools
      libyaml.dev
      jq
      direnv

      # Nix tools
      nix-prefetch
      nix-search-cli

      # Programming languages and tools
      pnpm
      rustc
      ruby_3_4
      nixd
      nixfmt

      # Fonts
      powerline-fonts
      powerline-symbols
      jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono

      # Python with common packages
      (python313.withPackages (ps: with ps; [
        jupyter
        notebook
        ipython
      ]))
    ];

    home.file = {
      # Configuration files
      ".ripgreprc".source = ../lib/ripgreprc;
      ".tmux.conf".source = ../lib/tmux.conf;
      ".tmuxinator" = {
        source = ../lib/tmuxinator;
        recursive = true;
      };
      ".aliases".source = ../lib/aliases;
      ".bin" = {
        source = ../lib/bin;
        recursive = true;
      };
      ".scripts" = {
        source = ../lib/scripts;
        recursive = true;
      };

      # Shell configuration
      ".zshrc".text = finalZshrc;
      ".zshrc.extend" = mkIf (cfg.zshrc.sourceExtension != null) {
        source = cfg.zshrc.sourceExtension;
      };
      ".zsh" = {
        source = ../lib/zsh;
        recursive = true;
      };

      # Tool configurations
      "Library/Application Support/lazygit/config.yml".source = ../lib/lazy-git-config.yml;
    };

    programs = {
      zsh.enable = true;

      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      claude-code = {
        enable = true;
        memory.source = ../lib/claude/CLAUDE.md;
        commandsDir = ../lib/claude/commands;
        preClean = true;
      };
    };
  };
}
