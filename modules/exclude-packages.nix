{ config, lib, ... }:

let
  inherit (lib) types mkOption mkIf;

  # Note that we're not using `pkgs` from the module arguments
  # This forces consumers to provide fully initialized pkgs
  cfg = config.modules.excludePackages;
in {
  options.modules.excludePackages = mkOption {
    type = types.listOf types.package;
    default = [];
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

  config = mkIf (cfg != []) {
    # Apply an overlay that replaces excluded packages with empty derivations
    nixpkgs.overlays = [ 
      (final: prev: 
        let 
          # Extract the names of packages to exclude
          exclusions = builtins.listToAttrs (
            map (p: {
              name = p.pname or p.name;
              value = prev.runCommand "${p.pname or p.name}" {
                # Inherit important attributes from the original package
                meta = (p.meta or {}) // {
                  description = "Package excluded by home-manager configuration (original: ${p.meta.description or "unknown"})";
                  # Keep the platforms from the original package
                  inherit (p.meta) platforms;
                  # Mark it with the lowest priority so it's never chosen if alternatives exist
                  priority = -1000;
                };
              } ''
                mkdir -p $out
                echo "This package (${p.pname or p.name}) was excluded by home-manager configuration" > $out/README
              '';
            }) cfg
          );
        in exclusions
      )
    ];
  };
}