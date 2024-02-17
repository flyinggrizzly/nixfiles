# Darwin options docs: https://daiderd.com/nix-darwin/manual/index.html

{ pkgs, ... }: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # TODO: remove on resolution of https://github.com/LnL7/nix-darwin/issues/682
  # Hotfix from https://github.com/nix-community/home-manager/issues/4026
  users.users.seandmr.home = "/Users/seandmr";

  # Home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.seandmr = { pkgs, ... }: {
      home = {
        stateVersion = "22.11";

        packages = [
          pkgs.alacritty
        ];

        file = {
          "Library/Application Support/Alfred/Alfred.alfredpreferences" = {
            source = ../../lib/Alfred.alfredpreferences;
            recursive = true;
          };
          "Library/Application Support/Alfred/prefs.json".source = ../../lib/alfred-prefs.json;
        };
      };

      imports = [
        ../../configs/git.nix
        ../../configs/terminal.nix
        ../../configs/vim.nix
      ];

      programs.home-manager.enable = true;
    };
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation = {
      # TODO: do I really want to wait for this crap?
      autoUpdate = true;
      upgrade = true;
    };
    autoUpdate = true;
    casks = [
      "1password"
      "alfred"
      "logseq"
      "discord"
      "google-chrome"
      "iterm2"
      "karabiner-elements"
      "keepingyouawake"
      "kitty"
      "nordvpn"
      "obsidian"
      "pdf-expert"
      "rectangle"
      "slack"
      "the-unarchiver"
      "transmission"
      "visual-studio-code"
      "vlc"
    ];
  };

  # OS pains in the ass
  system.defaults ={
    NSGlobalDomain = {
      NSDocumentSaveNewDocumentsToCloud = false;

      # Expand save modals by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Expand print modals by default
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;

      # Enable tap-to-click
      "com.apple.mouse.tapBehavior" = 1;
    };
    dock = {
      autohide = true;
      launchanim = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      #ShowPathBar = true;
    };
    menuExtraClock = {
      Show24Hour = true;
      #ShowDate = true;
    };
  };
}
