# syslog

_shit I've done parallel to these dotfiles_.

## 2024-10-30 Update to macOS 15 Sequoia

Trying to invoke a nix build command after the Sequoia upgrade resulted in

`=> the user '_nixbld1' in the group nixbld does not exist`

[This issue on the Nix project](https://github.com/NixOS/nix/issues/10892) describes the issue, and the fix, which was,
at time of writing, to invoke their migration script:

```
curl --proto '=https' --tlsv1.2 -sSf -L https://github.com/NixOS/nix/raw/master/scripts/sequoia-nixbld-user-migration.sh | bash -
```
