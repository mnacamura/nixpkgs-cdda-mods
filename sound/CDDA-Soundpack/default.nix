{ stdenv, fetchurl, cataclysmDDAPackages }:

with cataclysmDDAPackages;

buildCDDASoundPack rec {
  soundPackName = "CDDA-Soundpack";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/budg3/CDDA-Soundpack/archive/v${version}.tar.gz";
    sha256 = "1yw3g2ssg083psa1210l040wd0q5hrb2x9vpsawbyhr665kc6wg8";
  };

  meta = with stdenv.lib; {
    description = "A soundpack based on ChestHole's with some RRFSounds mixed in";
    homepage = "https://github.com/budg3/CDDA-Soundpack/";
    license = licenses.unfree;
    maintainers = [];
    platforms = platforms.all;
  };
}
