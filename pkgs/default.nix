{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mod = {
    Ninja = callPackage ./mods/Ninja {};
  };

  soundpack = {
    CDDA = callPackage ./soundpacks/CDDA {};
    COAG = callPackage ./soundpacks/COAG {};
    atmark = callPackage ./soundpacks/atmark {};
  };
in

{ inherit mod soundpack; }
