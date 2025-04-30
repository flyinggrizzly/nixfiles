{ config, pkgs, lib, ... }:

let
  # Create a base JSON configuration file that will be part of the Nix store
  baseConfigJson = pkgs.writeTextFile {
    name = "base-config.json";
    text = ''
      {
        "app": {
          "name": "MyApp",
          "version": "1.0.0"
        },
        "settings": {
          "theme": "light",
          "language": "en"
        }
      }
    '';
  };

  # Database configuration that will be merged
  databaseConfig = {
    host = "localhost";
    port = 5432;
    user = "app_user";
    password = "app_password";
    pool = {
      maxConnections = 10;
      idleTimeout = 60
    };
  };

  # Logging configuration that will be merged
  loggingConfig = {
    level = "info";
    file = "/var/log/myapp.log";
    rotate = true;
    maxSize = "10MB";
    maxFiles = 5;
  };
in {
  # Import the file-copy module if it's not already imported
  imports = [ ../modules/file-copy.nix ];
  
  # Configure the file-copy module
  modules.fileCopy = {
    
    # First, copy the base JSON file to a writable location
    files = [
      {
        source = baseConfigJson;
        # Using the home directory in a path
        destination = "${config.home.homeDirectory}/.config/myapp/config.json";
      }
    ];
    
    # Then, merge additional configuration into specific keys
    mergePartialJsonConfigs = [
      # Add database configuration to the top level
      {
        destination = "${config.home.homeDirectory}/.config/myapp/config.json";
        key = "database";
        subJson = databaseConfig;
      }
      
      # Add logging configuration as a nested key
      {
        destination = "${config.home.homeDirectory}/.config/myapp/config.json";
        key = "settings.logging";
        subJson = loggingConfig;
      }
      
      # Update an existing key
      {
        destination = "${config.home.homeDirectory}/.config/myapp/config.json";
        key = "app.version";
        subJson = "1.1.0";  # String values are also supported
      }
    ];
  };
}