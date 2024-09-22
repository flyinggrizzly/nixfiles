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

## Neovim + Nix

We ain't using any vim package managers, as nice as lazy.vim is--most things are packaged by nix, and the update process
for packages is harder when managing 2 different lockfiles.

Process:

1. add the nix package from https://seach.nixos.org, into `programs.neovim.plugins`
    - if the packages isn't in `pkgs.vimPlugins`, you can add it manually with `pkgs.vimUtils.buildVimPlugin`
   - if it's from a github repo, you can also use the custom function `% nix-git-sha` helper to generate the sha256 value to lock it
2. for language servers, we're not using `mason.nvim` to handle installation. Instead these also need to get installed
   with nix (or with the software project like for Sorbet/Ruby/Rubocop--there's handling in `plugin_config/lsp.lua`
for missing servers), into `programs.neovim.extraPackages`
    - once that's done, you should be able to reference the language server normally from the LSP setup process
3. similarly, for treesitter, rather than use `mason` to install the necessary grammars, we're just using
   the `nvim-treesitter.withAllGrammars` plugin nix package. We could do it piecemeal, but it's not worth the hassle
   to me
4. set up any necessary neovim config, probably in `lib/nvim/lua/plugin_config/MY_PLUGIN.lua`
