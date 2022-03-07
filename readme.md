# Home-manager config

1. Install Nix and [nix home-manager](https://nixos.wiki/wiki/Home_Manager)
2. run `home-manager switch` to activate the Nix environment

Some tools still need to be installed directly:

- `nvm` for managing node versions
- `brew`, if running on a Mac

Also, there are a few GUI apps not available in Nix. Use the Brefile at `~/.Brewfile` as a reference, or install using it.

