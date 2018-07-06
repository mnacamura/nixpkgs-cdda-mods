{ callPackage }:

let
  mods = {
    hokuto = callPackage ./mods/hokuto {};
  };

  soundpacks = {
  };
in

{
  cataclysmDDAPackages = mods // soundpacks;
}
