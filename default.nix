self: super:

with self;

let
  withMorePkgs = newPkgs: oldPkgs:
  lib.recursiveUpdate oldPkgs {
    mod = {
    };

    soundpack = {
      atmark = callPackage ./soundpacks/atmark {};
    };

    tileset = {
    };
  };

  availableFor = build: _: mod:
  if isNull build then
    true
  else if build.isTiles then
    mod.forTiles
  else
    mod.forCurses;

  filterAvailablePkgsFor = build: pkgs:
  lib.mapAttrs (_: mod: lib.filterAttrs (availableFor build) mod) pkgs;
in

{
  cataclysmDDA = super.cataclysmDDA // rec {
    pkgs = super.cataclysmDDA.pkgs.extend withMorePkgs;

    stable = rec {
      tiles = super.cataclysmDDA.stable.tiles.overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = filterAvailablePkgsFor tiles pkgs;
          withMods = cataclysmDDA.wrapCDDA tiles;
        };
      });

      curses = (tiles.override { tiles = false; }).overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = filterAvailablePkgsFor curses pkgs;
          withMods = cataclysmDDA.wrapCDDA curses;
        };
      });
    };

    git = rec {
      tiles = super.cataclysmDDA.git.tiles.overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = filterAvailablePkgsFor tiles pkgs;
          withMods = cataclysmDDA.wrapCDDA tiles;
        };
      });

      curses = (tiles.override { tiles = false; }).overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = filterAvailablePkgsFor curses pkgs;
          withMods = cataclysmDDA.wrapCDDA curses;
        };
      });
    };
  };
}
