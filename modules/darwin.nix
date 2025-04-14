{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.options) mkOption;
  inherit (pkgs.stdenv) isDarwin;

  # Mock package for ghostty as noted in original config
  ghostty-mock = pkgs.writeShellScriptBin "ghostty-mock" ''
    true
  '';
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

  config = mkIf config.modules.darwin.enable {
    assertions = [
      {
        # Raise **unless** the module is disabled or we're on Darwin
        assertion = !config.modules.darwin.enable || isDarwin;
        message = "Darwin module cannot be enabled on non-macOS systems";
      }
    ];

    # Darwin-specific packages
    home.packages = with pkgs; [
      iterm2
      rectangle
    ];

    # Mac package for ghostty is busted, use homebrew version
    programs.ghostty.package = ghostty-mock;

    # Homebrew integration
    home.sessionVariables = {
      HOMEBREW_BUNDLE_FILE = "$HOME/.Brewfile";
    };

    # File configurations
    home.file = {
      # Homebrew
      ".Brewfile".source = config.modules.darwin.brewfile;

      # Alfred configuration (conditional)
      "Library/Application Support/Alfred/Alfred.alfredpreferences" = mkIf config.modules.darwin.alfred.enable {
        source = ../lib/Alfred.alfredpreferences;
        recursive = true;
      };
      "Library/Application Support/Alfred/prefs.json" = mkIf config.modules.darwin.alfred.enable {
        source = ../lib/alfred-prefs.json;
      };
      
      # Karabiner configuration (conditional)
      ".config/karabiner" = mkIf config.modules.darwin.karabiner.enable {
        source = ../lib/karabiner;
        recursive = true;
      };
    };
  };
}
