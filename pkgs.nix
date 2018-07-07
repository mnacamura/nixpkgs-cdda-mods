{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mods = {
    hokuto = callPackage ./mods/hokuto {};
  };

  soundpacks = {
    CDDA-Soundpack = callPackage ./sound/CDDA-Soundpack {};
  };
in

mods // soundpacks
