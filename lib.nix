{ stdenv, cataclysmDDAPackages }:

with cataclysmDDAPackages;

let
  makeBuildCDDAPackage = type:
  assert stdenv.lib.elem type [
    "mod"
    "soundpack"
  ];
  { modName, version, src, ... } @ args:
  stdenv.mkDerivation (args // rec {

    name = args.name or "cataclysm-dda-mod-${modName}-${version}";

    isTiles = true;
    isConsole =
      if type == "mod" then true
      else if type == "soundpack" then false
      else null;

    modRoot = args.modRoot or modName;

    configurePhase = args.configurePhase or ":";
    buildPhase = args.buildPhase or ":";

    installPhase = args.installPhase or (
      let
        parentDir =
          if type == "mod" then "mods"
          else if type == "soundpack" then "sound"
          else null;
      in ''
        runHook preInstall

        destdir="$out/share/cataclysm-dda/${parentDir}"
        mkdir -p "$destdir"
        cp -R "${modRoot}" "$destdir/${modName}"

        runHook postInstall
      '');
  });
in

rec {
  # Check if a given cataclysm-dda is tiles build.
  isTiles = unwrapped:
  builtins.any (f: f == "TILES=1") unwrapped.makeFlags;

  # Check if a given cataclysm-dda is console build.
  isConsole = unwrapped:
  !isTiles unwrapped;

  # Wrap a binary so that it can be installed with mods and soundpacks.
  wrapCDDA = callPackage ./wrapper.nix {};

  # Define a mod package.
  buildCDDAMod = makeBuildCDDAPackage "mod";

  # Define a soundpack package.
  buildCDDASoundPack = makeBuildCDDAPackage "soundpack";
}
