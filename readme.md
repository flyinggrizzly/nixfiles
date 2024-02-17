## darwin instructions

1. install `nix`, enable `flakes`
2. install homebrew
3. clone to `~/nixfiles`
4. run `bin/darwin-build` to build the first generation (see "Installation" section of https://xyno.space/post/nix-darwin-introduction)
5. force OS X to accept what we're doing:

```bash
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
```

6. run `bin/darwin-init`
7. for updates, run `bin/darwin-switch`


## resources

- home-manager + nix-darwin: https://xyno.space/post/nix-darwin-introduction
- chris portela blowing my mind
    - https://github.com/chrisportela/dotfiles
    - https://www.chrisportela.com/posts/home-manager-flake/
    - https://www.chrisportela.com/posts/published-nix-dotfiles/
