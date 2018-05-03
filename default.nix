self: super:

{
  inherit (super.callPackage ./lib {}) wrapCDDA buildCDDAMod;

  cataclysm-dda = self.wrapCDDA super.cataclysm-dda {
    mods = [];
  };

  cataclysm-dda-console = self.wrapCDDA super.cataclysm-dda {
    tiles = false;
    mods = [];
  };

  cataclysm-dda-git = self.wrapCDDA super.cataclysm-dda-git {
    mods = [];
  };

  cataclysm-dda-console-git = self.wrapCDDA super.cataclysm-dda-git {
    tiles = false;
    mods = [];
  };

  cataclysmDDAMods = {
  };
}
