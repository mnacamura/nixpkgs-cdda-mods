{ lib, cataclysmDDA, fetchurl, unzip }:

{
  UndeadPeople = cataclysmDDA.buildTileSet {
    modName = "UndeadPeople";
    version = "2020-11-04";
    src = fetchurl {
      name = "UndeadPeople-2020-11-04.zip";
      url = "https://github.com/SomeDeadGuy/UndeadPeopleTileset/archive/a0497221a22fb3264685f8c7e10cb7829470cc58.zip";
      sha256 = "09ixfm1w8bcl016sjmnk3x82jv2dx1qr5zvdbgxav2l3gv3fzdcn";
    };
    nativeBuildInputs = [ unzip ];
    modRoot = "MSX++UnDeadPeopleEdition";
    meta = with lib; {
      homepage = "https://github.com/SomeDeadGuy/UndeadPeopleTileset";
    };
  };
}
