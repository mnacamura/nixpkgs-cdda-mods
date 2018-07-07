{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mods = {
    hokuto = callPackage ./mods/hokuto {};
    Ninja = callPackage ./mods/Ninja {};
  };

  soundpacks = {
    CDDA-Soundpack = callPackage ./sound/CDDA-Soundpack {};
  };
in

mods // soundpacks
