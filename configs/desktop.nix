{ pkgs, ... }:

{
  home.packages = [
    pkgs.logseq
    pkgs.google-chrome
    pkgs.code-cursor
  ];

  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    settings = {
      theme = "calamity";
      cursor-style = "underline";
      font-family = "JetBrains Mono";
    };
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles = {
        default = {
          extensions = with pkgs.vscode-extensions; [
            asvetliakov.vscode-neovim
            bierner.markdown-mermaid
          ];
          userSettings = {
            "vscode-neovim.compositeKeys" = {
              "jk" = {
                "command" = "vscode-neovim.escape";
              };
            };
            "vscode-neovim.compositeKeys" = {
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
  };
}
