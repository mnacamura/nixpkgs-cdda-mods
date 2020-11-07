{ lib, cataclysmDDA, fetchurl, fetchFromGitHub, unzip }:

{
  UndeadPeople = cataclysmDDA.buildTileSet {
    modName = "UndeadPeople";
    version = "2020-11-07";
    src = fetchFromGitHub {
      owner = "SomeDeadGuy";
      repo = "UndeadPeopleTileset";
      rev = "953063d0902b2716c12935245e8e496c5968ae59";
      sha256 = "1w2c8sqjwj2q42ywakiad6my9s57la8sf7rxv8nmv50y3hiz9r8m";
    };
    modRoot = "MSX++UnDeadPeopleEdition";
    meta = with lib; {
      homepage = "https://github.com/SomeDeadGuy/UndeadPeopleTileset";
    };
  };
}
