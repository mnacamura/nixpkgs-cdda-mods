{ cataclysmDDA, fetchurl, unzip }:

{
  ChestHole = cataclysmDDA.buildSoundPack {
    modName = "ChestHole";
    version = "2015-12-12";
    src = fetchurl {
      url = "http://chezzo.com/cdda/ChestHoleSoundSet.zip";
      sha256 = "1d9p1ilxyd64r0xwzvnp30hsgp7aza16p03rwi6h9v2gbd9mmzda";
    };
    nativeBuildInputs = [ unzip ];
  };
  ChestOldTimey = cataclysmDDA.buildSoundPack {
    modName = "ChestOldTimey";
    version = "2016-09-21";
    src = fetchurl {
      url = "http://chezzo.com/cdda/ChestOldTimeyLessismore.zip";
      sha256 = "0v4gx1lhpc5fw55hfymf1c0agp5bacs9c3h0qgcmc62n6ys4gxhi";
    };
    nativeBuildInputs = [ unzip ];
  };
  ChestHoleCC = cataclysmDDA.buildSoundPack {
    modName = "ChestHoleCC";
    version = "2016-09-21";
    src = fetchurl {
      url = "http://chezzo.com/cdda/ChestHoleCCSoundset.zip";
      sha256 = "07cw5gm7kfxzr2xadpmdv932kz4l5lf9ks8rfh6a4b5fl53lapz7";
    };
    nativeBuildInputs = [ unzip ];
  };
  RRFSounds = cataclysmDDA.buildSoundPack {
    modName = "RRFSounds";
    version = "2016-01-10";
    src = fetchurl {
      url = "https://www.dropbox.com/s/d8dfmb2facvkdh6/RRFSounds.zip";
      sha256 = "0pcqjww85dlwwxw1kh8gwl8x7da1svrwc6lrbj5vgabrq50r07w2";
    };
    nativeBuildInputs = [ unzip ];
    modRoot = "sound/RRFSounds";
  };
  budg3 = cataclysmDDA.buildSoundPack {
    modName = "budg3";
    version = "1.3";
    src = fetchurl {
      url = "https://github.com/budg3/CDDA-Soundpack/archive/v1.3.zip";
      sha256 = "1i3hh9nrkw20y0py4lacfghhlqva3dwx8xpfbi3rcm6qsp08ri6c";
    };
    nativeBuildInputs = [ unzip ];
    modRoot = "CDDA-Soundpack";
  };
  atsign = cataclysmDDA.buildSoundPack {
    modName = "atsign";
    version = "0.2";
    src = fetchurl {
      url = "https://github.com/damalsk/damalsksoundpack/archive/v0.2.zip";
      sha256 = "1xn0r7yq9pvsfwln6pqi7zj3za6hd10qcy7hq5xy82a47n26dhfw";
    };
    nativeBuildInputs = [ unzip ];
  };
  Otopack = cataclysmDDA.buildSoundPack {
    modName = "Otopack";
    version = "2020-10-28";
    src = fetchurl {
      url = "https://github.com/Kenan2000/Otopack-Mods-Updates/archive/29a8421d4951e80a280928a595a45084dba1b5d4.zip";
      sha256 = "11gy9vasmffpjgshl3jb7w8x6x5iyh4byhh4smszzjs23xziqkpg";
    };
    nativeBuildInputs = [ unzip ];
    modRoot = "Otopack+ModsUpdates";
  };
}
