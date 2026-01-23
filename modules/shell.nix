{
  config,
  lib,
  pkgs,
  tmuxinator-nix,
  helpers,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.modules.shell;
  baseZshrc = builtins.readFile ../lib/zshrc;
  finalZshrc = baseZshrc + "\n# Appended ZSH configuration\n" + cfg.zshrc.append;
in
{
  options.modules.shell = {
    zshrc = {
      append = mkOption {
        type = types.str;
        default = "";
        description = ''
          Additional ZSH configuration to append to zshrc.
        '';
      };
    };
  };

  imports = [ ./shell/tmux.nix ];

  config = {
    home.packages = with pkgs; [
      _1password-cli

      # Core terminal utilities
      mosh

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
      exiftool

      # Development tools
      libyaml.dev
      jq
      direnv
      gdb

      # Nix tools
      nix-prefetch
      nix-search-cli

      # Programming languages and tools
      pnpm
      ruby_3_4
      nixd
      nixfmt-rfc-style
      opencode

      # Fonts
      powerline-fonts
      powerline-symbols
      jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono

      # Python with common packages
      (python313.withPackages (
        ps: with ps; [
          jupyter
          notebook
          ipython
        ]
      ))
    ];

    home.file = {
      # Configuration files
      ".ripgreprc".source = ../lib/ripgreprc;
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
      ".zsh" = {
        source = ../lib/zsh;
        recursive = true;
      };

      # Tool configurations
      "Library/Application Support/lazygit/config.yml".source = ../lib/lazy-git-config.yml;
    };

    programs = {
      zsh = {
        enable = true;
        initContent = finalZshrc;
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      claude-code = {
        enable = true;
        commands = helpers.claude.commandDirToTable ../lib/claude/commands;
        mcpServers = { };
      };

      wiggum.enable = true;
    };
  };
}
