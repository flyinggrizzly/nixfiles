{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.options) mkOption;
  inherit (pkgs.stdenv) isDarwin;

  # Mock package for ghostty as noted in original config
  ghostty-mock = pkgs.writeShellScriptBin "ghostty-mock" ''
    true
  '';

  cfg = config.modules.darwin;

  addIf = condition: package: if condition then [ package ] else []; 
in {
  options.modules.darwin = {
    enable = mkEnableOption "Enable macOS-specific configuration";

    brewfile = mkOption {
      type = types.path;
      default = ../lib/Brewfile;
      description = "Path to the Brewfile for homebrew packages";
    };

    alfred.enable = mkOption {
      description =  "Enable Alfred configuration";
      type = types.bool;
      default = true;
    };

    karabiner.enable = mkOption {
      description = "Enable Karabiner configuration";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.enable || isDarwin;
        message = "Darwin module cannot be enabled on non-macOS systems";
      }
    ];

    home.packages = with pkgs; [
      iterm2
      rectangle
      the-unarchiver
    ] ++ (addIf cfg.karabiner.enable karabiner-elements);

    programs.ghostty.package = ghostty-mock;

    home.sessionVariables = {
      HOMEBREW_BUNDLE_FILE = "$HOME/.Brewfile";
    };

    home.file = {
      ".Brewfile".source = cfg.brewfile;

      "Library/Application Support/Alfred/Alfred.alfredpreferences" = mkIf cfg.alfred.enable {
        source = ../lib/Alfred.alfredpreferences;
        recursive = true;
      };
      "Library/Application Support/Alfred/prefs.json" = mkIf cfg.alfred.enable {
        source = ../lib/alfred-prefs.json;
      };

      ".config/karabiner" = mkIf cfg.karabiner.enable {
        source = ../lib/karabiner;
        recursive = true;
      };
    };
  };
}
