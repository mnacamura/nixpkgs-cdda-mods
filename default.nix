self: super:

with self;

let
  withMorePkgsFor = build: newPkgs: oldPkgs:
  lib.recursiveUpdate oldPkgs (filterAvailablePkgsFor build {
    mod = {
    };

    soundpack = super.callPackage ./soundpacks.nix {};

    tileset = {
    };
  });

  addMorePkgsTo = build:
  let
    self = build.overrideAttrs (old: {
      passthru = old.passthru // {
        pkgs = old.passthru.pkgs.extend (withMorePkgsFor self);
        withMods = cataclysmDDA.wrapCDDA self;
      };
    });
  in
  self;

  filterAvailablePkgsFor = build: pkgs:
  lib.mapAttrs (_: mods: lib.filterAttrs (availableFor build) mods) pkgs;

  availableFor = build: _: mod:
  if isNull build then
    true
  else if build.isTiles then
    mod.forTiles
  else
    mod.forCurses;
in

{
  cataclysmDDA = super.cataclysmDDA // (with super.cataclysmDDA; {
    pkgs = pkgs.extend (withMorePkgsFor null);

    stable = {
      tiles = addMorePkgsTo stable.tiles;
      curses = addMorePkgsTo stable.curses;
    };

    git = {
      tiles = addMorePkgsTo git.tiles;
      curses = addMorePkgsTo git.curses;
    };
  });
}
