{ stdenv, fetchFromGitHub, cataclysmDDAPackages }:

with cataclysmDDAPackages;

buildCDDAMod rec {
  modName = "Ninja";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hirmiura";
    repo = "cdda-mod-Ninja";
    rev = version;
    sha256 = "0sm9wkm6ahfp95qsqfz2rwp58y0sbbhsq3fnk3ya7035dn1sgnas";
  };

  meta = with stdenv.lib; {
    description = "忍者の衣装・NPC・マップ等を追加するMOD";
    homepage = "https://github.com/hirmiura/cdda-mod-Ninja";
    license = licenses.unfree;
    maintainers = [];
    platforms = platforms.all;
  };
}
