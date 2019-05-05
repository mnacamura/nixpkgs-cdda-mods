{ stdenv, fetchFromGitHub, cataclysmDDAPackages }:

with cataclysmDDAPackages;

buildCDDASoundPack rec {
  soundPackName = "CDDA";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "budg3";
    repo = "CDDA-Soundpack";
    rev = "v${version}";
    sha256 = "1p955g7yxi3gw7a21w6x929wmjblcq526kzx8fzk57mhzs7vd2zx";
  };

  soundPackRoot = "CDDA-Soundpack";

  meta = with stdenv.lib; {
    description = "A C:DDA soundpack based on ChestHole's with some RRFSounds mixed in";
    homepage = "https://github.com/budg3/CDDA-Soundpack";
    license = licenses.unfree;
    maintainers = [];
    platforms = platforms.all;
  };
}
