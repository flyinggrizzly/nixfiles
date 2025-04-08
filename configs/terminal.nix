{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    powerline-fonts
    powerline-symbols

    mosh

    tmux
    tmuxinator

    git
    gh
    lazygit

    wget
    ripgrep
    fd
    fzf
    tree
    yt-dlp

    libyaml

    nix-prefetch
    nix-search-cli

    pnpm
    rustc

    jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono

    jq

    graphite-cli

    claude-code

    direnv

    chruby

    (python313.withPackages (ps: with ps; [
      jupyter
      notebook
      ipython
    ]))
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
  home.file."Library/Application Support/lazygit/config.yml".source = ../lib/lazy-git-config.yml;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
