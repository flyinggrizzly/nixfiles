{ config, pkgs, lib, ... }: 
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkMerge mkIf types;
  inherit (lib.options) mkOption;
in
{
  options.osxConfig = {
    brewfileName = mkOption {
      type = types.path;
      default = ../lib/Brewfile;
    };
  };

  # Conditionally include this Mac-specific config if we're on a Darwin system
  config = mkMerge [
    {}
    (mkIf isDarwin {
      home = {
        # NOTE: dependency for lib/zsh/functions/brew-up
        file.".Brewfile".source = config.osxConfig.brewfileName;
        sessionVariables = {
          HOMEBREW_BUNDLE_FILE = "$HOME/.Brewfile";
        };

        file = {
          "Library/Application Support/Alfred/Alfred.alfredpreferences" = {
            source = ../lib/Alfred.alfredpreferences;
            recursive = true;
          };

          "Library/Application Support/Alfred/prefs.json".source = ../lib/alfred-prefs.json;

          # Karabiner config (OSX only)
          ".config/karabiner" = {
            source = ../lib/karabiner;
            recursive = true;
          };
        };
      };
    })
  ];
}
