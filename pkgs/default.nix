{ lib, callPackage, build ? null, oldPkgs }:

let
  pkgs = lib.recursiveUpdate {
    inherit (oldPkgs) mod soundpack tileset;
  } {
    mod = callPackage ./mods.nix {};
    soundpack = callPackage ./soundpacks.nix {};
    tileset = callPackage ./tilesets.nix {};
  };

  pkgs' = lib.mapAttrs (_: mods: lib.filterAttrs isAvailable mods) pkgs;

  isAvailable = _: mod:
  if isNull build then
    true
  else if build.isTiles then
    mod.forTiles or false
  else if build.isCurses then
    mod.forCurses or false
  else
    false;
in

lib.makeExtensible (_: pkgs')
