# tests/standalone_minimal_test.nix
#
# Test for standalone home with minimal configuration

{ pkgs, lib, getPlatformPkgs, createDerivation }:

createDerivation {
  name = "standalone-minimal";
  config = lib.standaloneHome {
    username = "tester";
    stateVersion = "24.11";
    platform = "x86_64-linux";

    # Disable optional modules
    neovim.enable = false;
    git.enable = false;
    desktop.enable = false;
    darwin.enable = false;
  };
}