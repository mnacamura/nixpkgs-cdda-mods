{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mod = {
    Ninja = callPackage ./mods/Ninja {};
  };

  soundpack = {
    CDDA = callPackage ./soundpacks/CDDA {};
  };
in

{ inherit mod soundpack; }
