{ lib, cataclysmDDA, fetchurl, unzip }:

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
}
