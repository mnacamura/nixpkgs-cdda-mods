{ lib, cataclysmDDA, fetchurl, fetchFromGitHub, unzip }:

{
  ChestHole = cataclysmDDA.buildSoundPack {
    modName = "ChestHole";
    version = "2015-12-12";
    src = fetchurl {
      name = "ChestHole-2015-12-12.zip";
      url = "http://chezzo.com/cdda/ChestHoleSoundSet.zip";
      sha256 = "1d9p1ilxyd64r0xwzvnp30hsgp7aza16p03rwi6h9v2gbd9mmzda";
    };
    nativeBuildInputs = [ unzip ];
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/ambient-sounds/9710/182";
    };
  };
  ChestOldTimey = cataclysmDDA.buildSoundPack {
    modName = "ChestOldTimey";
    version = "2016-09-21";
    src = fetchurl {
      name = "ChestOldTimey-2016-09-21.zip";
      url = "http://chezzo.com/cdda/ChestOldTimeyLessismore.zip";
      sha256 = "0v4gx1lhpc5fw55hfymf1c0agp5bacs9c3h0qgcmc62n6ys4gxhi";
    };
    nativeBuildInputs = [ unzip ];
    meta = with lib; {
      homepage = "https://www.reddit.com/r/cataclysmdda/comments/53ndzx/music_recommendations_to_listen_to_while_playing/d7vfd7w";
    };
  };
  ChestHoleCC = cataclysmDDA.buildSoundPack {
    modName = "ChestHoleCC";
    version = "2016-09-21";
    src = fetchurl {
      name = "ChestHoleCC-2016-09-21.zip";
      url = "http://chezzo.com/cdda/ChestHoleCCSoundset.zip";
      sha256 = "07cw5gm7kfxzr2xadpmdv932kz4l5lf9ks8rfh6a4b5fl53lapz7";
    };
    nativeBuildInputs = [ unzip ];
    meta = with lib; {
      homepage = "https://www.reddit.com/r/cataclysmdda/comments/53ndzx/music_recommendations_to_listen_to_while_playing/d7vfd7w";
    };
  };
  RRFSounds = cataclysmDDA.buildSoundPack {
    modName = "RRFSounds";
    version = "2016-01-10";
    src = fetchurl {
      name = "RRFSounds-2016-01-10.zip";
      url = "https://www.dropbox.com/s/d8dfmb2facvkdh6/RRFSounds.zip";
      sha256 = "0pcqjww85dlwwxw1kh8gwl8x7da1svrwc6lrbj5vgabrq50r07w2";
    };
    nativeBuildInputs = [ unzip ];
    modRoot = "sound/RRFSounds";
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/ambient-sounds/9710/201";
    };
  };
  budg3 = cataclysmDDA.buildSoundPack {
    modName = "budg3";
    version = "1.3";
    src = fetchFromGitHub {
      owner = "budg3";
      repo = "CDDA-Soundpack";
      rev = "v1.3";
      sha256 = "1p955g7yxi3gw7a21w6x929wmjblcq526kzx8fzk57mhzs7vd2zx";
    };
    modRoot = "CDDA-Soundpack";
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/cdda-soundpack/15329";
    };
  };
  atsign = cataclysmDDA.buildSoundPack {
    modName = "atsign";
    version = "2019-06-07";
    src = fetchFromGitHub {
      owner = "damalsk";
      repo = "damalsksoundpack";
      rev = "a69ed2bb65350b2700004b42fca02a5559fd8dad";
      sha256 = "1s6rvanljl1rkyz8xj1ypqgs43adhm2iackq3zngyfmmgiyj80gz";
    };
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/soundpack-s-soundpack-vehicle-sounds-licensed-music-and-more/20131";
    };
  };
  Otopack = cataclysmDDA.buildSoundPack {
    modName = "Otopack";
    version = "2020-11-05";
    src = fetchFromGitHub {
      owner = "Kenan2000";
      repo = "Otopack-Mods-Updates";
      rev = "53369d6c6beed58937dfe4bbcba98a260119b1d2";
      sha256 = "1kz6brdfg3g7xkdf1algspz42nvsy4bw5y14qasjrnan1vrlr673";
    };
    modRoot = "Otopack+ModsUpdates";
    meta = with lib; {
      homepage = "https://github.com/Kenan2000/Otopack-Mods-Updates";
    };
  };
}
