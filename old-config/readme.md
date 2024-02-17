# Home-manager config

1. Install Nix and [nix home-manager](https://nixos.wiki/wiki/Home_Manager)
2. run `home-manager switch` to activate the Nix environment

The `bin/bootstrap` script does not do *everything*, but it'll get there. For
now it'll set up the two foundation symlinks, and print out instructions for
what to do next.

Some tools still need to be installed directly:

- `nvm` for managing node versions `brew`, if running on a Mac

Also, there are a few GUI apps not available in Nix. Use the Brefile at
`~/.Brewfile` as a reference, or install using it.

## TODO

- [ ] chruby via nix? (can't do NVM, so...)
- [ ] move GUI apps out to own file
- [ ] ensure separation of personal/work concerns
- [ ] handle NVM and non-GUI apps for non-Mac situations (still depending on Homebrew atm) (this might just be ruby-install)
- [ ] automate more of the bootstrap script
- [ ] Set up Shopify specific config (not in this repo, but to be handled by `home.nix`)
- [ ] Set up importing of work-specific dotfiles from outside the repo

## Setup

There are a few flag files that this setup creates. First, there is the
`~/.nix-source-dir`, which contains the path to the repository. This is so that
the dotfiles can point back to the actual sourcefiles, for things like updating
vim spellings. Obviously if you move or rename the repo, this will need to get
updated.

The other important one is the `~/.machine-identifier` dotfile, which holds the
machine identifier. This is used by home-manager to determine which profile to
apply, and can support zsh functionality as well.

## Tools for managing config

1. `bin/link-config` makes the two foundational symlinks
2. `bin/bootstrap` will eventually manage the whole set up and update process
3. Zsh functions
  - `brew-commit` updates the active Homebrew packages commit to this repo
  - `brew-up` installs packages from Homebrew defined in `lib/Brewfile`
  - `hu` is shorthand for `home-manager switch -b backup` to update config
  - `he` opens the `home.nix` config for editing
  - `nix-source-dir` reads out the content of `~/.nix-source-dir`, which is set up by `bin/link`. This is mostly for the dotfile tooling to use, but can be handy
