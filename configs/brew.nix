{ config, pkgs, ... }: {

  # NOTE: dependency for lib/zsh/functions/brew-up
  home.file.".Brewfile".source = ../lib/Brewfile;
  home.sessionVariables = {
    HOMEBREW_BREWFILE = "$HOME/.Brewfile";
  };
}
