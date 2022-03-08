{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "seandmr";
  home.homeDirectory = "/Users/seandmr";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  home.packages = [
    pkgs.alacritty

    pkgs.tmux
    pkgs.tmuxinator

    pkgs.neovim

    pkgs.git
    pkgs.gh

    pkgs.ripgrep
    pkgs.tree
    pkgs.youtube-dl

    pkgs.docker

    pkgs.nerdfonts

    # pkgs._1password-gui
    # pkgs.dropbox
    # pkgs.firefox
    # pkgs.google-chrome
    pkgs.vscode-with-extensions
  ];

  home.file.".tmux.conf".source = ./tmux.conf;
  home.file.".gitconfig".source = ./gitconfig;
  home.file.".aliases".source = ./aliases;
  home.file.".bin" = {
    source = ./bin;
    recursive = true;
  };
  home.file.".gitmessage".source = ./gitmessage;
  home.file.".Brewfile".source = ./Brewfile;

  # Karabiner config (OSX only)
  home.file.".config/karabiner" = {
    source = ./karabiner;
    recursive = true;
  };

  # ZSH
  home.file.".zshrc".source = ./zshrc;
  home.file.".zsh" = {
    source = ./zsh;
    recursive = true;
  };

  # VIM config
  home.file.".vim" = {
    source = ./vim;
    recursive = true;
  };
  home.file.".config/nvim/init.vim".source = ./nvim/init.vim;
  home.file.".vimrc".source = ./vimrc;
  home.file.".vimrc.bundles".source = ./vimrc.bundles;
  home.file.".vim-spell" = {
    source = ./vim-spell;
    recursive = true;
  };

  # TODO
  # - chruby via nix
  # - move GUI apps out to own file
  # - ensure separation of personal/work concerns
  # - handle NVM and non-GUI apps for non-Mac situations (still depending on Homebrew atm) (this might just be ruby-install)

  # Shopify specific installations

  #shopify_env = builtins.pathExists ~/.shopify-env;
  # if shopify_env then import(./shopify.nix)
}
