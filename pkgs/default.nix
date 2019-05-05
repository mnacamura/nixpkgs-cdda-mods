{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mods = {
    Ninja = callPackage ./mods/Ninja {};
  };

  soundpacks = {
    CDDA-Soundpack = callPackage ./soundpacks/CDDA-Soundpack {};
  };
in

mods // soundpacks
