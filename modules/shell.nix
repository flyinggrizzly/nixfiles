{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      # Core terminal utilities
      mosh
      tmux
      tmuxinator

      # Version control
      git
      gh
      lazygit

      # File and text utilities
      wget
      ripgrep
      fd
      fzf
      tree
      yt-dlp

      # Development tools
      libyaml
      jq
      direnv

      # Nix tools
      nix-prefetch
      nix-search-cli

      # Programming languages and tools
      pnpm
      rustc
      chruby
      graphite-cli
      claude-code

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
      ".zshrc".source = ../lib/zshrc;
      ".zshrc.extend".source = ../lib/zshrc.extend;
      ".zsh" = {
        source = ../lib/zsh;
        recursive = true;
      };

      # Tool configurations
      "Library/Application Support/lazygit/config.yml".source = ../lib/lazy-git-config.yml;
      ".claude" = {
        source = ../lib/claude;
        recursive = true;
      };
    };

    programs = {
      zsh.enable = true;

      direnv = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
