## home-manager only instructions

1. install `nix`, enable `flakes`
2. install homebrew
3. clone to `~/nixfiles`
4. run `bin/switch`
5. run `brew-up` to install any Homebrew software defined in the created `~/.Brewfile` (we could use `nix-darwin`, but
   it introduces a lot of complexity and you still need to install homebrew manually anyways... not totally worth the
   lift. But if I ever change my mind there's a working spike (as of 2024-02-18) at https://github.com/flyinggrizzly/nixfiles/tree/nix-darwin-spike)

## resources

- home-manager + nix-darwin: https://xyno.space/post/nix-darwin-introduction
- chris portela blowing my mind
    - https://github.com/chrisportela/dotfiles
    - https://www.chrisportela.com/posts/home-manager-flake/
    - https://www.chrisportela.com/posts/published-nix-dotfiles/
- [configuring LSP servers without Mason on nix](https://github.com/LazyVim/LazyVim/discussions/1972)
   - using LazyVim as a reference, but the "add to `extraPackages` part is the important bit"
   - used [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua) for a lot of the basic telescope/lsp/etc setup: 
