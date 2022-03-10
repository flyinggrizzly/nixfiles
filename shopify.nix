{ config, pkgs, ... }:

{
  imports = [
    ./terminal.nix
    ./git.nix
    ./vim.nix
  ];

  home.file.".Brewfile".source = ./lib/Brewfile.shopify;

  # Karabiner config (OSX only)
  home.file.".config/karabiner" = {
    source = ./lib/karabiner;
    recursive = true;
  };
}

