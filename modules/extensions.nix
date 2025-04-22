{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.modules.extensions;
in {
  options.modules.extensions = mkOption {
    type = types.attrsOf types.anything;
    default = {};
    description = "Allows extending any configuration attributes (deep merged with existing config)";
  };

  config = cfg;
}