{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.modules.homeExtensions;
in {
  options.modules.homeExtensions = mkOption {
    type = types.attrsOf types.anything;
    default = {};
    description = "Allows extending home configuration with additional settings (deep merged with existing config)";
  };

  config = {
    # Apply the home extensions to the home module
    # This will be merged with the existing home configuration thanks to NixOS module system
    home = cfg;
  };
}