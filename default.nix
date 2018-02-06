self: super:

with self;

{
  inherit (super.callPackage ./lib {}) wrapCDDA buildCDDAMod;

  cataclysm-dda = wrapCDDA super.cataclysm-dda { mods = []; };
  cataclysm-dda-console = wrapCDDA super.cataclysm-dda { tiles = false; mods = []; };
  cataclysm-dda-git = wrapCDDA super.cataclysm-dda-git { mods = []; };
  cataclysm-dda-git-console = wrapCDDA super.cataclysm-dda-git { tiles = false; mods = []; };

  cataclysmDDAMods = {
  };
}
