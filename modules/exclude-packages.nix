{ config, lib, ... }:

let
  inherit (lib) types mkOption mkIf;
  excludeList = config.modules.excludePackages;
in
{
  options.modules.excludePackages = mkOption {
    type = types.listOf types.package;
    default = [ ];
    description = ''
      List of packages to exclude from installation.
      IMPORTANT: These must be fully initialized package derivations, not functions.

      Example:
        excludePackages = let
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        in [
          pkgs.nano
          pkgs.vi
        ];
    '';
  };

  config = mkIf (excludeList != [ ]) {
    nixpkgs.overlays = [
      (
        final: prev:
        let
          excludeSet = builtins.listToAttrs (
            map (p: {
              name = p.pname or p.name;
              value = p; # Store the original package for metadata
            }) excludeList
          );

          # Create the overlay with empty packages only for excluded ones
          excludeOverlay = builtins.mapAttrs (
            name: origPkg:
            prev.runCommand name
              {
                # Keep the original package's metadata but modify as needed
                meta = (origPkg.meta or { }) // {
                  description = "Package excluded by home-manager configuration (original: ${
                    origPkg.meta.description or "unknown"
                  })";
                  inherit (origPkg.meta) platforms;
                  priority = -1000;
                };
              }
              ''
                mkdir -p $out
                echo "This package (${name}) was excluded by home-manager configuration" > $out/README
              ''
          ) excludeSet;
        in
        # Return only the overlay for excluded packages
        excludeOverlay
      )
    ];
  };
}
