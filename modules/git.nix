{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.git;
in {
  options.modules.git = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Git configuration";
    };

    username = mkOption {
      type = types.str;
      default = "Sean DMR";
      description = "Git user name";
    };

    email = mkOption {
      type = types.str;
      default = "sean@flyinggrizzly.net";
      description = "Git user email";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional Git configuration options";
    };
  };

  config = mkIf cfg.enable {
    # Basic git configuration will go here
    programs.git = {
      enable = true;
      userName = cfg.username;
      userEmail = cfg.email;

      ignores = [
        "*.pyc"
        "*.sw[nop]"
        ".DS_Store"
        ".bundle"
        ".byebug_history"
        ".env"
        ".git/"
        "/bower_components/"
        "/log"
        "/node_modules/"
        "/tmp"
        "/vendor"
        "db/*.sqlite3"
        "log/*.log"
        "rerun.txt"
        "tmp/**/*"
        "/tags"
      ];

      aliases = {
        l = "log --pretty-colored";
        st = "status";
        d = "diff";
        dd = "difftool";
        hist = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        branches = "for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes";
        co = "checkout";
        cp = "cherry-pick";
        po = "!git push -u origin \"$(git rev-parse --abbrev-ref HEAD)\"";
        cane = "commit --amend --no-edit";
        # git add -p will also interact with untracked files
        ap = "!git add --intent-to-add && git add -p";
        hide = "update-index --skip-worktree";
        unhide = "update-index --no-skip-worktree";
        squash = "rebase -i --autosquash";
      };

      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
        rebase.autosquash = true;
        push.default = "current";
        commit.verbose = true;
        diff.tool = "vimdiff";
        absorb.maxStack = 50;

        # Add any custom git config
        core.editor = "nvim";
        diff.algorithm = "patience";
        merge.conflictstyle = "diff3";

        # Merge user's extra config
      } // cfg.extraConfig;
    };

    home.packages = [
      pkgs.git-absorb
    ];

    home.file = {
      ".gitmessage".source = ../lib/gitmessage;
    };
  };
}
