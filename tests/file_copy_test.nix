{
  pkgs,
  lib,
}:

let
  testConfig = lib.standaloneHome {
    username = "test-user";
    stateVersion = "24.11";
    platform = "x86_64-linux";
    extraModules = [
      ../modules/file-copy.nix
      ({ ... }: {
        modules.fileCopy = {
          enable = true;
          files = [
            {
              source = ../lib/zshrc;
              destination = "/tmp/test-file-copy-zshrc";
            }
            {
              source = ../lib/ripgreprc;
              destination = "/tmp/test-file-copy-ripgreprc";
            }
          ];
        };
      })
    ];
  };
in {
  # This allows us to test that our configuration builds without errors
  fileCopyTest = testConfig.activationPackage;
}