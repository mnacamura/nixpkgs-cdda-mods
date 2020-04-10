self: super:

with self;

let
  withMorePkgsFor = build: newPkgs: oldPkgs:
  lib.recursiveUpdate oldPkgs (filterAvailablePkgsFor build {
    mod = {
    };

    soundpack = {
      atmark = callPackage ./soundpacks/atmark {};
    };

    tileset = {
    };
  });

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
    pkgs = super.cataclysmDDA.pkgs.extend (withMorePkgsFor null);

    stable = rec {
      tiles = super.cataclysmDDA.stable.tiles.overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = old.passthru.pkgs.extend (withMorePkgsFor tiles);
          withMods = cataclysmDDA.wrapCDDA tiles;
        };
      });

      curses = (tiles.override { tiles = false; }).overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = old.passthru.pkgs.extend (withMorePkgsFor curses);
          withMods = cataclysmDDA.wrapCDDA curses;
        };
      });
    };

    git = rec {
      tiles = super.cataclysmDDA.git.tiles.overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = old.passthru.pkgs.extend (withMorePkgsFor tiles);
          withMods = cataclysmDDA.wrapCDDA tiles;
        };
      });

      curses = (tiles.override { tiles = false; }).overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = old.passthru.pkgs.extend (withMorePkgsFor curses);
          withMods = cataclysmDDA.wrapCDDA curses;
        };
      });
    };
  };
}
