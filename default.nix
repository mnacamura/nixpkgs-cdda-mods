self: super:

with self.cataclysmDDAPackages;

let
  cataclysm-dda = wrapCDDA super.cataclysm-dda {
    packages = [];
  };

  cataclysm-dda-console = wrapCDDA super.cataclysm-dda {
    tiles = false;
    packages = [];
  };

  cataclysm-dda-git = wrapCDDA super.cataclysm-dda-git {
    packages = [];
  };

  cataclysm-dda-git-console = wrapCDDA super.cataclysm-dda-git {
    tiles = false;
    packages = [];
  };

  lib = callPackage ./lib.nix {};

  pkgs = callPackage ./pkgs {};
in

{
  inherit
  cataclysm-dda
  cataclysm-dda-console
  cataclysm-dda-git
  cataclysm-dda-git-console;

  cataclysmDDAPackages = {
    callPackage = super.newScope self;

    inherit (lib)
    isTiles
    isConsole
    forTiles
    forConsole
    wrapCDDA
    buildCDDAMod
    buildCDDASoundPack
    ;

    inherit (pkgs) mod soundpack;
  };
}
