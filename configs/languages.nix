{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.elixir
  ];
}
