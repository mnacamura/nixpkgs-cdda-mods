# Automatically generated by `update-mods.scm`. DO NOT EDIT!
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
    version = "2020-11-20";
    src = fetchFromGitHub {
      owner = "Noctifer-de-Mortem";
      repo = "nocts_cata_mod";
      rev = "3e181a73dd41158dd32f6dc737e8a2f75616260f";
      sha256 = "13bhh959rshbyw8qziib2k17h1f6i750r83yxpby19va17lx4rrm";
    };
    meta = with lib; {
      homepage = "https://discourse.cataclysmdda.org/t/cataclysm-mod/10523";
    };
  };
}
