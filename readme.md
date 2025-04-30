# nixfiles: Cross-Platform Nix Configuration

A modular Home Manager configuration that works across multiple platforms:

- macOS laptops and desktops
- Linux servers and workstations
- Shared configurations with conditional overrides

## Installation

### Using the Template (Recommended)
1. Create a new repository using the default template:
   ```bash
   nix flake new -t github:seandmr/nixfiles#default my-config
   cd my-config
   ```

2. Customize the configuration in `flake.nix` with your settings:
   - Set your `username` and `hostname`
   - Configure modules according to your preferences
   - Update system architecture as needed

3. Apply your configuration:
   ```bash
   home-manager switch --flake .
   ```

### Direct Installation
1. Install `nix` and enable `flakes` support
2. On macOS, install Homebrew
3. Clone this repository to `~/nixfiles`
4. Run the switch script to activate:
   ```
   bin/switch
   ```

The script detects your current system and applies the correct configuration profile.

## Structure

The configuration is organized as follows:

```
nixfiles/
├── bin/                    # Helper scripts
│   └── switch              # Activation script
├── flake.nix               # Main entry point
├── hosts/                  # Host-specific configurations
│   ├── m1-grizzly.nix      # Personal macOS laptop
│   ├── work-mac.nix        # Work laptop configuration
│   └── homelab.nix         # Server configuration
├── lib/                    # Configuration files and resources
│   ├── nvim/               # Neovim configuration
│   ├── zsh/                # ZSH configuration
│   └── ...                 # Other resources
├── modules/                # Modular configurations
│   ├── core.nix            # Core options and imports
│   ├── darwin.nix          # macOS-specific configuration
│   ├── desktop.nix         # GUI applications and settings
│   ├── exclude-packages.nix # Package exclusion system
│   ├── file-copy.nix       # Copy writable files after activation
│   ├── git.nix             # Git configuration
│   ├── neovim.nix          # Neovim setup
│   ├── secrets.nix         # Secret management
│   └── shell.nix           # Terminal and shell setup
└── secrets/                # Secret files (gitignored)
```

## Modules

Each module includes:

1. An `enable` option to toggle it on/off
2. Configuration specific to its purpose
3. Options for fine-grained control of module features

### Module Activation

Each module has an `enable` option that controls whether the module is active. This is set in the host configuration file.

For example, to enable the desktop module:

```nix
modules.desktop.enable = true;
```

The configuration is completely modular, with each host choosing which modules to enable without relying on system type flags.

## Configuration Reference

The `prepareHome` function in `flake.nix` accepts the following configuration options:

### Core Parameters

```nix
prepareHome {
  username = "user";
  platform = "x86_64-linux"; # Renamed from system
  stateVersion = "24.05";
  
  # Module configurations...
  shell = {};
  neovim = {};
  git = {};
  desktop = {};
  darwin = {};
  fileCopy = {};
  excludePackages = [];
  
  # Additional configuration through extraModules
  extraModules = [
    # Custom configuration modules
    ({ config, lib, pkgs, ... }: {
      # Your direct configurations here
    })
  ];
}
```

### Using within NixOS Configuration

When using with NixOS, always wrap the function call in parentheses:

```nix
# In your NixOS configuration
modules = [
  (dotfiles.lib.nixosHome {
    username = "user";
    platform = "x86_64-linux";
    stateVersion = "24.05";
    # Module configurations...
  })
];
```

### Module Configuration
#### Adding Custom Configuration

You can add custom configurations using the `extraModules` parameter:

```nix
extraModules = [
  ({ config, lib, pkgs, ... }: {
    # Direct configuration for any home-manager settings
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };
    
    xdg.configFile."myapp/settings.json".text = ''{ "theme": "dark" }'';
    
    home.packages = with pkgs; [ 
      ripgrep 
      fd
    ];
  })
];
```

The `extraModules` parameter is handled through the module system. Each module in the list
is imported automatically and its configuration is applied to your home-manager setup.

#### Git

```nix
git = {
  enable = true;           # Enable/disable Git configuration
  username = "Your Name";  # Git user.name
  email = "your@email.com"; # Git user.email
  extraConfig = {          # Additional Git configuration
    pull.rebase = true;
    init.defaultBranch = "main";
  };
};
```

#### Shell

```nix
shell = {
  zshrc = {
    sourceExtension = ./path/to/additional.zsh; # Optional path to an additional zsh config file
    append = ''
      # Additional zsh configuration to append to zshrc
      alias ll='ls -la'
      export MY_ENV_VAR="value"
    '';
  };
};
```

#### Neovim

```nix
neovim = {
  enable = true;           # Enable/disable Neovim configuration
  enableLlmTools = true;   # Enable/disable AI coding assistants
  extraPlugins = [];       # Additional Vim plugins
  extraPackages = [];      # Additional system packages for Neovim
  extraConfig = '''         # Additional Lua configuration
    vim.opt.colorcolumn = "80"
  ''';
  llmLuaOverride = null;   # Optional path to custom LLM config
};
```

#### Desktop

```nix
desktop = {
  enable = true;           # Enable/disable desktop applications
  ghostty.enable = true;   # Enable/disable Ghostty terminal configuration
  kitty.enable = true;     # Enable/disable Kitty terminal configuration
  vscode.enable = true;    # Enable/disable VSCode configuration
};
```

#### Darwin (macOS specific)

```nix
darwin = {
  enable = true;           # Enable macOS-specific configuration
  brewfile = ./Brewfile;   # Path to Homebrew bundle file
  alfred.enable = true;    # Enable Alfred configuration
  karabiner.enable = true; # Enable Karabiner Elements configuration
};
```

#### File Copy

The file-copy module allows you to create writable copies of files after the home-manager generation is complete:

```nix
modules.fileCopy = {
  # List of files to copy
  files = [
    {
      # Source file to copy from (can be a path or a derivation output)
      source = ../config/app.conf;
      
      # Destination path where writable copy will be created
      destination = "/etc/app/config.conf";
    }
    {
      # You can also reference files from your home-manager profile
      source = "${config.home.path}/etc/some-generated-file.conf";
      destination = "/var/lib/app/config.conf";
    }
    {
      # Use relative paths for destination - they are relative to $HOME
      source = ../config/app-user-config.conf;
      destination = ".config/app/config.conf";
    }
  ];
  
  # Merging partial JSON configs into existing JSON files
  mergePartialJsonConfigs = [
    {
      # Path to an existing JSON file
      destination = "/etc/app/config.json";
      
      # JSON key where to merge the subJson (supports nested keys with dot notation)
      key = "database";
      
      # Attribute set that will be converted to JSON and merged at the key
      subJson = {
        host = "localhost";
        port = 5432;
        user = "dbuser";
      };
    }
    {
      destination = "/etc/app/settings.json";
      key = "logging.settings";  # Supports nested keys with dot notation
      subJson = {
        level = "debug";
        file = "/var/log/app.log";
      };
    }
    {
      # Use relative paths for destination - they are relative to $HOME
      destination = ".config/app/user-settings.json";
      key = "preferences";
      subJson = {
        darkMode = true;
        fontSize = 14;
      };
    }
  ];
};
```

This module provides two main features:

1. **File Copying**: Creates world-writable copies of specified files outside of the Nix store, allowing them to be modified directly. Files are copied anew on each home-manager generation, overwriting any previous changes.

2. **JSON Merging**: Merges JSON fragments into specific locations within existing JSON files. This is useful for:
   - Adding configuration to existing JSON files without replacing the entire file
   - Updating specific sections of configuration files while preserving the rest
   - Dynamically generating parts of configuration files

The JSON merging feature requires that the destination file already exists (it will fail otherwise) and uses `jq` to perform the merging operation. The module automatically adds `jq` as a dependency.

### Example Configuration

```nix
homeConfigurations."user@host" = lib.standaloneHome {
  username = "user";
  platform = "x86_64-linux";
  stateVersion = "24.05";
  
  git = {
    username = "User Name";
    email = "user@example.com";
  };
  
  neovim.enableLlmTools = false;
  
  desktop = {
    enable = true;
    ghostty.enable = true;
    kitty.enable = true;
    vscode.enable = true;
  };
  
  fileCopy = {
    files = [
      {
        source = ./config/myapp.conf;
        destination = "/etc/myapp/config.conf";
      }
    ];
    mergePartialJsonConfigs = [
      {
        destination = "/etc/myapp/settings.json";
        key = "database.credentials";
        subJson = {
          user = "app_user";
          password = "app_password";
          host = "localhost";
        };
      }
    ];
  };
  
  # Custom configuration through extraModules
  extraModules = [
    ({ config, lib, pkgs, ... }: {
      home.file.".config/custom/settings.json".text = ''{ "setting": "value" }'';
      home.packages = [ pkgs.ripgrep ];
      home.sessionVariables = { EDITOR = "nvim"; };
      programs.starship.enable = true;
    })
    
    # Include the file-copy module
    ../modules/file-copy.nix
    
    # Configure the file-copy module
    ({ ... }: {
      modules.fileCopy = {
        enable = true;
        files = [
          {
            source = ../config/some-file.conf;
            destination = "/etc/app/config.conf";
          }
        ];
      };
    })
  ];
};
```

## Neovim + Nix

The Neovim configuration uses Nix for plugin management, not vim plugin managers:

1. Add plugins in `modules/neovim.nix` in the `plugins` list
   - For packages not in `pkgs.vimPlugins`, use `pkgs.vimUtils.buildVimPlugin`
   - For GitHub plugins, use `nix-git-sha` to generate the sha256 hash

2. Language servers go in `programs.neovim.extraPackages`

3. Neovim configuration is in `lib/nvim/`

### LLM Tools Integration

The Neovim configuration includes optional LLM integration with tools like CodeCompanion and Copilot:

- **Enable/Disable LLM Tools**: Set `neovim.enableLlmTools` to `true` or `false` in your configuration
- **Custom LLM Configuration**: Provide your own LLM setup with `neovim.llmLuaOverride`

Example configuration:

```nix
neovim = {
  enable = true;
  enableLlmTools = true;  # Set to false to disable LLM tools entirely
  
  # Optional: provide a custom LLM configuration
  llmLuaOverride = ./path/to/custom-llms.lua;
};
```

## Testing

This flake includes a comprehensive test suite that verifies all configuration options work correctly. The tests can be run on any system without actually switching configurations.

### Running Tests

The simplest way to run tests is using the provided script:

```bash
# Run all tests
bin/test

# Run specific test groups
bin/test minimal     # Minimal configuration tests
bin/test complete    # Complete configuration tests with all options
bin/test standalone  # Standalone home-manager tests
bin/test nixos       # NixOS integration tests
bin/test exclude     # Package exclusion test
bin/test filecopy    # File copy module test
bin/test jsonmerge   # JSON merge functionality test
```

You can also run tests directly with Nix:

```bash
# Run all tests
nix build .#packages.$(nix eval --impure --expr "builtins.currentSystem").tests

# Run specific tests
nix build .#packages.$(nix eval --impure --expr "builtins.currentSystem").tests.testStandaloneComplete
nix build .#packages.$(nix eval --impure --expr "builtins.currentSystem").tests.testNixosComplete
nix build .#packages.$(nix eval --impure --expr "builtins.currentSystem").tests.testExcludePackages
nix build .#packages.$(nix eval --impure --expr "builtins.currentSystem").tests.testFileCopy
```

### What the Tests Verify

The tests simulate consuming this flake from another flake and verify that these configurations can be properly evaluated:

1. `testStandaloneComplete` - A comprehensive standalone home-manager configuration with all options enabled
2. `testStandaloneMinimal` - A minimal standalone home-manager configuration with only required options
3. `testNixosComplete` - A comprehensive NixOS configuration with home-manager integration and all options enabled
4. `testNixosMinimal` - A minimal NixOS configuration with home-manager integration
5. `testExcludePackages` - A configuration testing the package exclusion functionality
6. `testFileCopy` - A test for the file-copy module that creates writable file copies

### Testing Your Own Flakes

When developing a flake that uses this configuration as a dependency, you can verify that your configuration builds correctly without switching to it:

```bash
# For standalone home-manager configuration
nix build .#homeConfigurations.<username>@<hostname>.activationPackage --no-link

# For NixOS configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel --no-link
```

## Resources

- [home-manager + nix-darwin](https://xyno.space/post/nix-darwin-introduction)
- [Chris Portela's dotfiles](https://github.com/chrisportela/dotfiles)
- [Configuring LSP servers without Mason on nix](https://github.com/LazyVim/LazyVim/discussions/1972)
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
