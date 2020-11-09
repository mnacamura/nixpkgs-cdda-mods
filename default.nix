self: super:

let
  inherit (super) lib;

  pkgs' = lib.recursiveUpdate {
    inherit (super.cataclysmDDA.pkgs) mod soundpack tileset;
  } {
    mod = super.callPackage ./generated/mods.nix {};
    soundpack = super.callPackage ./generated/soundpacks.nix {};
    tileset = super.callPackage ./generated/tilesets.nix {};
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

  jenkins = self.callPackage ./generated/jenkins.nix {};
in

{
  cataclysmDDA = super.cataclysmDDA // {
    inherit pkgs jenkins;

    stable = with super.cataclysmDDA; {
      tiles = updatePkgs stable.tiles;
      curses = updatePkgs stable.curses;
    };

    git = with super.cataclysmDDA; {
      tiles = updatePkgs git.tiles;
      curses = updatePkgs git.curses;
    };
  };
}
