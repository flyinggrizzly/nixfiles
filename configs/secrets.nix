{ lib, ... }:
let
  inherit (builtins) pathExists;
  inherit (lib) mkMerge mkIf;

  zshSecrets = ../secrets/zsh;
in {
  config = mkMerge [
    {}

    # Create a ~/.zsh.secrets file if any secrets are defined, which will be loaded by ~/.zshrc if it exists.
    #
    # Allows for setting secrets in envvars without tracking them into git.
    (mkIf (pathExists zshSecrets) {
      home.file.".zsh.secrets".source = zshSecrets;
    })
  ];
}
