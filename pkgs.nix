{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mods = {
    Ninja = callPackage ./mods/Ninja {};
  };

  soundpacks = {
    CDDA-Soundpack = callPackage ./sound/CDDA-Soundpack {};
  };
in

mods // soundpacks
