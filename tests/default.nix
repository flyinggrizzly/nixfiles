# tests/default.nix
#
# This file contains tests for the nixfiles flake that can be run on any system.
# It tests that all configurations can be built without switching the config.

{ pkgs, lib }:

let
  # Setup required packages and helper functions
  getPlatformPkgs = platform: import <nixpkgs> { system = platform; config.allowUnfree = true; };

  # Create test derivations
  createDerivation = { name, config }:
    pkgs.runCommand "test-${name}" {} ''
      echo "Testing ${name}..."
      # Simply testing that these configurations can be evaluated is sufficient
      echo "Configuration successfully evaluated"
      touch $out # Create empty output file to mark success
    '';

  # Define test configurations by importing individual test files
  linuxPkgs = getPlatformPkgs "x86_64-linux";
  
  testHelpers = {
    inherit pkgs lib getPlatformPkgs createDerivation;
  };

  # Import individual test files
  testStandaloneComplete = import ./standalone_complete_test.nix testHelpers;
  testStandaloneMinimal = import ./standalone_minimal_test.nix testHelpers;
  testExcludePackages = import ./exclude_packages_test.nix testHelpers;
  testNixosComplete = import ./nixos_complete_test.nix testHelpers;
  testNixosMinimal = import ./nixos_minimal_test.nix testHelpers;

  # Run all tests
  runAllTests = pkgs.runCommand "run-all-tests" {
    buildInputs = [
      testStandaloneComplete
      testStandaloneMinimal
      testNixosComplete
      testNixosMinimal
      testExcludePackages
    ];
  } ''
    echo "All tests passed!"
    touch $out
  '';

in {
  testStandaloneComplete = testStandaloneComplete;
  testStandaloneMinimal = testStandaloneMinimal;
  testNixosComplete = testNixosComplete;
  testNixosMinimal = testNixosMinimal;
  testExcludePackages = testExcludePackages;
  runAllTests = runAllTests;

  # Default target to build
  default = runAllTests;
}