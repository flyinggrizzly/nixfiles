{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  
  # Access the toplevel extraModules parameter from modules
  cfg = config.extraModules or [];
in {
  # Define the option at the top level
  options.extraModules = mkOption {
    type = types.listOf types.anything;
    default = [];
    description = "Additional modules to include in the home-manager configuration";
  };

  # Apply the extraModules by importing them directly
  imports = cfg;
}