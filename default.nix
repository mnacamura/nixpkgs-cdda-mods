self: super:

with self;

{
  inherit (super.callPackage ./lib {}) wrapCDDA buildCDDAMod;

  cataclysm-dda = wrapCDDA super.cataclysm-dda { mods = []; };

  cataclysm-dda-with-mods = mods: wrapCDDA super.cataclysm-dda { mods = mods; };

  cataclysm-dda-git = wrapCDDA super.cataclysm-dda-git { mods = []; };

  cataclysm-dda-git-with-mods = mods: wrapCDDA super.cataclysm-dda-git { mods = mods; };

  cataclysmDDAMods = {
  };
}
