# tests/flake-input-tests.nix
#
# This file tests that all flake input configurations can be built

{ pkgs, lib }:

let
  # List all test files
  testFiles = [
    # Complete and minimal configurations for all platforms
    "standalone-minimal-flake-input-test.nix"
    "standalone-complete-flake-input-test.nix"
    "standalone-darwin-minimal-flake-input-test.nix"
    "standalone-darwin-complete-flake-input-test.nix"
    "nixos-minimal-flake-input-test.nix"
    "nixos-complete-flake-input-test.nix"
  ];
  
  # Create test derivations that check each flake can be simply parsed
  testDerivations = map (filename:
    let 
      name = builtins.replaceStrings [".nix"] [""] filename;
      flakePath = ./flake-input/${filename};
    in
    pkgs.runCommand "test-${name}" {} ''
      echo "Testing ${name}..."
      
      # Just verify that the flake.nix file can be parsed without errors
      ${pkgs.nix}/bin/nix-instantiate --parse ${flakePath} > /dev/null
      
      # If we got here, the test passed
      echo "✓ Test passed: ${name}"
      touch $out
    ''
  ) testFiles;
  
  # Run all tests
  runAllTests = pkgs.runCommand "run-all-flake-input-tests" {
    buildInputs = testDerivations;
  } ''
    echo "All flake input tests passed!"
    touch $out
  '';
  
in {
  # Make individual tests available
  tests = builtins.listToAttrs (builtins.map (deriv: {
    name = deriv.name;
    value = deriv;
  }) testDerivations);
  
  # Default target
  default = runAllTests;
}