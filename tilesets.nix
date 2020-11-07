{ lib, cataclysmDDA, fetchurl, fetchFromGitHub, unzip }:

{
  UndeadPeople = cataclysmDDA.buildTileSet {
    modName = "UndeadPeople";
    version = "2020-11-07";
    src = fetchFromGitHub {
      owner = "SomeDeadGuy";
      repo = "UndeadPeopleTileset";
      rev = "513e1af96cbd01aea919d3816fd9efbea47f1c0b";
      sha256 = "0b50hwwhrfrpfs92vj25xk3ql3y54raahfxx60vq1r069kfzffpb";
    };
    modRoot = "MSX++UnDeadPeopleEdition";
    meta = with lib; {
      homepage = "https://github.com/SomeDeadGuy/UndeadPeopleTileset";
    };
  };
}
