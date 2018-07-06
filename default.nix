self: super:

let
  lib = self.callPackage ./lib.nix {};

  cataclysm-dda = self.wrapCataclysmDDA super.cataclysm-dda {
    packages = [];
  };

  cataclysm-dda-console = self.wrapCataclysmDDA super.cataclysm-dda {
    tiles = false;
    packages = [];
  };

  cataclysm-dda-git = self.wrapCataclysmDDA super.cataclysm-dda-git {
    packages = [];
  };

  cataclysm-dda-git-console = self.wrapCataclysmDDA super.cataclysm-dda-git {
    tiles = false;
    packages = [];
  };

  pkgs = self.callPackage ./pkgs.nix {};
in

{
  callPackage = super.newScope self;

  inherit (lib)
  wrapCataclysmDDA
  buildCataclysmDDAMod
  buildCataclysmDDASoundPack;

  inherit
  cataclysm-dda
  cataclysm-dda-console
  cataclysm-dda-git
  cataclysm-dda-git-console;

  inherit (pkgs)
  cataclysmDDAPackages;
}
