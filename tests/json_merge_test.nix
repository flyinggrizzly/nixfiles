{
  pkgs,
  lib,
}:

let
  # Create a test JSON file that will be included in the Nix store
  testJsonFile = pkgs.writeTextFile {
    name = "test-json-file";
    text = ''
      {
        "app": {
          "name": "TestApp",
          "version": "1.0.0"
        },
        "settings": {
          "theme": "dark"
        }
      }
    '';
  };

  testConfig = lib.standaloneHome {
    username = "test-user";
    stateVersion = "24.11";
    platform = "x86_64-linux";

    fileCopy = {
      enable = true;

      # First copy the base JSON file
      files = [
        {
          source = testJsonFile;
          destination = "/tmp/test-json-merge-file.json";
        }
      ];

      # Then merge in additional JSON data
      mergePartialJsonConfigs = [
        {
          destination = "/tmp/test-json-merge-file.json";
          key = "database";
          subJson = {
            host = "localhost";
            port = 5432;
            user = "testuser";
            password = "testpass";
          };
        }
        {
          destination = "/tmp/test-json-merge-file.json";
          key = "settings.advanced";
          subJson = {
            debug = true;
            logLevel = "verbose";
          };
        }
      ];
    };
  };
in
{
  # This allows us to test that our configuration builds without errors
  jsonMergeTest = testConfig.activationPackage;
}
