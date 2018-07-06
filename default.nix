self: super:

let
  lib = self.callPackage ./lib.nix {};

  cataclysm-dda = self.wrapCDDA super.cataclysm-dda {
    packages = [];
  };

  cataclysm-dda-console = self.wrapCDDA super.cataclysm-dda {
    tiles = false;
    packages = [];
  };

  cataclysm-dda-git = self.wrapCDDA super.cataclysm-dda-git {
    packages = [];
  };

  cataclysm-dda-git-console = self.wrapCDDA super.cataclysm-dda-git {
    tiles = false;
    packages = [];
  };

  pkgs = self.callPackage ./pkgs.nix {};
in

{
  callPackage = super.newScope self;

  inherit (lib)
  wrapCDDA
  buildCDDAMod
  buildCDDASoundPack;

  inherit
  cataclysm-dda
  cataclysm-dda-console
  cataclysm-dda-git
  cataclysm-dda-git-console;

  inherit (pkgs)
  cataclysmDDAPackages;
}
