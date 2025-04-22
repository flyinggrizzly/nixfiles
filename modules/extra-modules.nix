{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;

  # Access the extraModules parameter from the modules namespace
  cfg = config.modules.extraModules;
in {
  # Define the option in the modules namespace
  options.modules.extraModules = mkOption {
    type = types.listOf types.anything;
    default = [];
    description = "Additional modules to include in the home-manager configuration";
  };

  # Apply the extraModules by importing them directly
  imports = cfg;
}