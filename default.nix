self: super:

let
  inherit (self) lib;

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
    this = build.overrideAttrs (old: {
      passthru = old.passthru // {
        pkgs = pkgsFor this;
        withMods = self.cataclysmDDA.wrapCDDA this;
      };
    });
  in
  this;

  jenkins = self.callPackage ./generated/jenkins.nix {};
in

{
  cataclysmDDA = super.cataclysmDDA // {
    inherit pkgs jenkins;

    # Required to fix `pkgs` and `withMods` attrs after applying `override` or `overrideAttrs`.
    # Example:
    # let
    #   myBuild = cataclysmDDA.jenkins.b11152.overrideAttrs (_: {
    #     enableParallelBuilding = true;
    #   });
    # 
    #   # This refers to the derivation before overriding!
    #   badExample = myBuild.withMods (_: []);
    # 
    #   # This is good. `myBuild` is correctly referred by `withMods`.
    #   goodExample = (cataclysmDDA.updatePkgs myBuild).withMods (_: []);
    # in
    # goodExample
    inherit updatePkgs;

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
