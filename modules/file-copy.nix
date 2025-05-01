{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.fileCopy;

  # Type definition for file copy entries
  fileCopyType = types.submodule {
    options = {
      source = mkOption {
        type = types.path;
        description = "Source file path to read from";
      };
      destination = mkOption {
        type = types.str;
        description = "Destination path to write to (absolute or relative to home directory)";
      };
    };
  };

  # Type definition for JSON merge entries
  jsonMergeType = types.submodule {
    options = {
      destination = mkOption {
        type = types.str;
        description = "Path to the JSON file to modify (absolute or relative to home directory)";
      };
      key = mkOption {
        type = types.str;
        description = "JSON key where to merge the subJson";
      };
      subJson = mkOption {
        type = types.attrs;
        description = "Attribute set that will be converted to JSON and merged";
      };
    };
  };

  # Helper function to escape single quotes for bash
  escapeQuotes = str: replaceStrings [ "'" ] [ "'\\''" ] str;

  # Convert an attrset to a JSON string, escaping quotes for bash
  attrsToJsonString = attrs: escapeQuotes (builtins.toJSON attrs);

  # Create temp file script
  tempFileScript = ''
    temp_file=$(mktemp)
    trap 'rm -f "$temp_file"' EXIT
  '';

  # Create the actual jq merge commands for each JSON merge entry
  createJqMergeCommands =
    merges:
    concatStringsSep "\n" (
      map (merge: ''
        # Resolve destination path (might be relative to home directory)
        dest_path="${merge.destination}"
        if [[ ! "$dest_path" = /* ]]; then
          dest_path="$HOME/${merge.destination}"
        fi

        # Create the parent directory with appropriate permissions if it doesn't exist
        parent_dir="$(dirname "$dest_path")"
        if [[ ! -d "$parent_dir" ]]; then
          echo "Creating directory: $parent_dir"
          $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$parent_dir"
          $DRY_RUN_CMD chmod $VERBOSE_ARG 755 "$parent_dir"
        fi

        # Process JSON merge at $dest_path for key ${merge.key}
        if [[ ! -f "$dest_path" ]]; then
          echo "Error: JSON file '$dest_path' does not exist. Cannot merge JSON data." >&2
          exit 1
        fi

        # Create a temporary JSON file with the subJson content
        echo '${attrsToJsonString merge.subJson}' > "$temp_file"

        # Use jq to merge the JSON at the specified key
        $DRY_RUN_CMD ${pkgs.jq}/bin/jq $VERBOSE_ARG --argjson data "$(cat "$temp_file")" '.${merge.key} = $data' "$dest_path" > "$temp_file.merged"

        # Check if jq command was successful
        if [ $? -ne 0 ]; then
          echo "Error: Failed to merge JSON at '$dest_path' for key '${merge.key}'" >&2
          exit 1
        fi

        # Replace the original file with the merged file
        $DRY_RUN_CMD mv $VERBOSE_ARG "$temp_file.merged" "$dest_path"

        # Set the file permissions
        $DRY_RUN_CMD chmod $VERBOSE_ARG 666 "$dest_path"
      '') merges
    );

  # Create file copy commands
  createFileCopyCommands =
    files:
    concatStringsSep "\n" (
      map (file: ''
        # Resolve destination path (might be relative to home directory)
        dest_path="${file.destination}"
        if [[ ! "$dest_path" = /* ]]; then
          dest_path="$HOME/${file.destination}"
        fi

        # Create the parent directory with appropriate permissions
        parent_dir="$(dirname "$dest_path")"
        echo "Creating directory: $parent_dir"
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$parent_dir"
        $DRY_RUN_CMD chmod $VERBOSE_ARG 755 "$parent_dir"

        # Copy file from ${file.source} to $dest_path
        echo "Copying ${file.source} to $dest_path"
        $DRY_RUN_CMD cp $VERBOSE_ARG "${file.source}" "$dest_path"
        $DRY_RUN_CMD chmod $VERBOSE_ARG 666 "$dest_path"
      '') files
    );
in
{
  options.modules.fileCopy = {
    files = mkOption {
      type = types.listOf fileCopyType;
      default = [ ];
      description = "List of file mappings to copy after home-manager generation";
    };
    mergePartialJsonConfigs = mkOption {
      type = types.listOf jsonMergeType;
      default = [ ];
      description = "List of JSON merge operations to perform after home-manager generation";
      example = literalExpression ''
        [
          {
            destination = "/path/to/config.json";
            key = "database";
            subJson = { host = "localhost"; port = 5432; };
          }
        ]
      '';
    };
  };
  config = {
    home.packages = [ pkgs.jq ];
    home.activation.copyFilesAndMergeJson = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Setup trap to clean up temp files
      ${tempFileScript}

      # Copy files
      ${createFileCopyCommands cfg.files}

      # Merge JSON files
      ${createJqMergeCommands cfg.mergePartialJsonConfigs}
    '';
  };
}
