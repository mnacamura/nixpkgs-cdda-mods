self: super:

let
  inherit (super) lib;

  oldPkgs = {
    inherit (super.cataclysmDDA.pkgs) mod soundpack tileset;
  };

  newPkgs = {
    mod = super.callPackage ./mods.nix {};
    soundpack = super.callPackage ./soundpacks.nix {};
    tileset = super.callPackage ./tilesets.nix {};
  };

  updatePkgs = build:
  let
    self = build.overrideAttrs (old: {
      passthru = old.passthru // {
        pkgs = pkgsFor self;
        withMods = super.cataclysmDDA.wrapCDDA self;
      };
    });
  in
  self;

  pkgsFor = build:
  let
    pkgs = lib.recursiveUpdate oldPkgs newPkgs;
    pkgs' = lib.mapAttrs (_: mods: lib.filterAttrs (availableFor build) mods) pkgs;
  in
  lib.makeExtensible (_: pkgs');

  availableFor = build: _: mod:
  if isNull build then
    true
  else if build.isTiles then
    mod.forTiles or false
  else if build.isCurses then
    mod.forCurses or false
  else
    false;
in

{
  cataclysmDDA = super.cataclysmDDA // (with super.cataclysmDDA; {
    pkgs = pkgsFor null;

    stable = {
      tiles = updatePkgs stable.tiles;
      curses = updatePkgs stable.curses;
    };

    git = {
      tiles = updatePkgs git.tiles;
      curses = updatePkgs git.curses;
    };
  });
}
