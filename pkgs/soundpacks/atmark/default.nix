{ lib, fetchFromGitHub, cataclysmDDAPackages }:

with cataclysmDDAPackages;

buildCDDASoundPack rec {
  modName = "atmark";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "damalsk";
    repo = "damalsksoundpack";
    rev = "v${version}";
    sha256 = "0vgv7sfwjfssv247i2czn823fvr0slqpz9z2p6fv8f03kx62bfx8";
  };

  modRoot = ".";

  meta = with lib; {
    description = "A C:DDA soundpack based on 2ch soundpack";
    homepage = https://github.com/damalsk/damalsksoundpack;
    license = licenses.unfree;
    maintainers = [ mnacamura ];
    platforms = platforms.all;
  };
}
