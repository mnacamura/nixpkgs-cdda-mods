self: super:

let
  inherit (super) lib;

  pkgs' = lib.recursiveUpdate {
    inherit (super.cataclysmDDA.pkgs) mod soundpack tileset;
  } {
    mod = super.callPackage ./mods.nix {};
    soundpack = super.callPackage ./soundpacks.nix {};
    tileset = super.callPackage ./tilesets.nix {};
  };

  pkgs = lib.makeExtensible (_: pkgs');

  pkgsFor = build:
  let
    availablePkgs = lib.mapAttrs (_: mods: lib.filterAttrs (availableFor build) mods) pkgs';
  in
  lib.makeExtensible (_: availablePkgs);

  availableFor = build: _: mod:
  if build.isTiles then
    mod.forTiles or false
  else if build.isCurses then
    mod.forCurses or false
  else
    false;

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

  jenkins = self.callPackage ./jenkins.nix {};
in

{
  cataclysmDDA = super.cataclysmDDA // (with super.cataclysmDDA; {
    inherit pkgs jenkins;

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
