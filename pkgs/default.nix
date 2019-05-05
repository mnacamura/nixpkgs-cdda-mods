{ cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  mod = {
    Ninja = callPackage ./mods/Ninja {};
  };

  soundpack = {
    CDDA = callPackage ./soundpacks/CDDA {};
    COAG = callPackage ./soundpacks/COAG {};
  };
in

{ inherit mod soundpack; }
