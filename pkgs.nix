{ callPackage }:

let
  mods = {
    hokuto = callPackage ./mods/hokuto {};
  };

  soundpacks = {
    CDDA-Soundpack = callPackage ./sound/CDDA-Soundpack {};
  };
in

{
  cataclysmDDAPackages = mods // soundpacks;
}
