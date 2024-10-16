{ config, pkgs, ... }: {
  home.file.".gitmessage".source = ../lib/gitmessage;

  home.packages = [
    pkgs.git-absorb
  ];

  programs.git = {
    enable = true;
    userName = "Sean DMR";
    userEmail = "sean@flyinggrizzly.net";

    extraConfig = {
      commit.verbose = true;
      core.editor = "$(which nvim)";
      diff.tool = "vimdiff";
      init.defaultBranch = "main";
      absorb.maxStack = 50;
    };

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
  };
}
