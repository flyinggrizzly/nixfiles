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

  home.packages = [
    pkgs.tmux
    pkgs.neovim
  ];

  home.file.".vimrc".source = ./vimrc;
  home.file.".vimrc.bundles".source = ./vimrc.bundles;
  home.file.".vim-spell" = {
    source = ./vim-spell;
    recursive = true;
  };

  # TODO
  # - Alacritty

  programs.git = {
    enable = true;

    userName = "Sean DMR";
    userEmail = "sean@flyinggrizzly.net";

    aliases = {
      l        = "log --pretty=colored";
      st       = "status";
      d        = "diff";
      dd       = "difftool";
      hist     = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      branches = "for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes";
      ci       = "commit -v";
      co       = "checkout";
      cp       = "cherry-pick";
      po       = "!git push -u origin \"$(git rev-parse --abbrev-ref HEAD)\"";
      ctags    = "!.git/hooks/ctags";
      cane     = "commit --amend --no-edit";
    };

    extraConfig = {
      core = {
        editor = "$(which nvim)";
      };

      commit = {
        verbose = true;
      };

      diff = {
        tool = "$(which vimdiff)";
      };

      difftool = {
        prompt = false;
      };

      pretty = {
        colored = "format:%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset";
      };
    };
  };
}
