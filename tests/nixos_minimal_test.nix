# tests/nixos_minimal_test.nix
#
# Test NixOS integration with minimal configuration

{ pkgs, lib, getPlatformPkgs, createDerivation }:

createDerivation {
  name = "nixos-minimal";
  config = lib.nixosHome {
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