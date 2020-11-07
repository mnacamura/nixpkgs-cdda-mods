{ lib, cataclysmDDA, fetchurl, fetchFromGitHub, unzip }:

{
  ArtyomsGunEmporium = cataclysmDDA.buildMod {
    modName = "ArtyomsGunEmporium";
    version = "2016-11-03";
    src = fetchurl {
      name = "ArtyomsGunEmporium-2016-11-03.zip";
      url = "https://www.dropbox.com/s/iudqj6ksnpo4i2r/Artyoms%27%20Gun%20Emporium.zip";
      sha256 = "02pja0sp7jj6sk29jq65jm5rnbh0vnlgfflr0p8ymcrk9y9q5jkr";
    };
    nativeBuildInputs = [ unzip ];
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/artyoms-gun-emporium-update-2-hotfix-1-holy-shit/10035/494";
    };
  };
  CataclysmPlusPlus = cataclysmDDA.buildMod {
    modName = "CataclysmPlusPlus";
    version = "2020-10-11";
    src = fetchFromGitHub {
      owner = "Noctifer-de-Mortem";
      repo = "nocts_cata_mod";
      rev = "91ff91998f865f87d43f2c1e31ec9040e3fe2fde";
      sha256 = "1d3k5q9999bqmc11abffnjhlr69mbvxyw9qkmwi9dn00904x0ws7";
    };
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/cataclysm-mod/10523";
    };
  };
}
