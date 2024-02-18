## home-manager only instructions

1. install `nix`, enable `flakes`
2. install homebrew
3. clone to `~/nixfiles`
4. run `bin/up`
5. run `bin/brew` to install any Homebrew software defined in the created `~/.Brewfile` (we could use `nix-darwin`, but
   it introduces a lot of complexity and you still need to install homebrew manually anyways... not totally worth the
   lift. But if I ever change my mind there's a working spike (as of 2024-02-18) at https://github.com/flyinggrizzly/nixfiles/tree/nix-darwin-spike)

## resources

- home-manager + nix-darwin: https://xyno.space/post/nix-darwin-introduction
- chris portela blowing my mind
    - https://github.com/chrisportela/dotfiles
    - https://www.chrisportela.com/posts/home-manager-flake/
    - https://www.chrisportela.com/posts/published-nix-dotfiles/
