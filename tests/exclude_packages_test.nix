# tests/exclude_packages_test.nix
#
# Test package exclusion functionality

{
  pkgs,
  lib,
  getPlatformPkgs,
  createDerivation,
}:

createDerivation {
  name = "exclude-packages";
  config =
    let
      linuxPkgs = getPlatformPkgs "x86_64-linux";

      # Generate a test home configuration with excluded packages
      testConfig = lib.standaloneHome {
        username = "tester";
        stateVersion = "24.11";
        platform = "x86_64-linux";

        # Exclude some packages from installation
        excludePackages = [
          linuxPkgs.ripgrep
          linuxPkgs.wget
        ];
      };

      # Add assertions to verify packages are excluded
      configWithAssertions = testConfig // {
        config = testConfig.config // {
          assertions = testConfig.config.assertions or [ ] ++ [
            {
              assertion =
                let
                  packages = testConfig.config.home.packages;
                  # Check if any package has the name "ripgrep" or "wget"
                  excludedFound = builtins.any (
                    pkg:
                    let
                      name = pkg.pname or pkg.name;
                    in
                    name == "ripgrep" || name == "wget"
                  ) packages;
                in
                !excludedFound; # Should be true if no excluded packages found
              message = "Excluded packages (ripgrep/wget) were found in home.packages";
            }
          ];
        };
      };
    in
    configWithAssertions;
}
