{ stdenv, cataclysmDDAPackages }:

with cataclysmDDAPackages;

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
  buildCDDAMod = { modName, version, src, ... } @ args:
  stdenv.mkDerivation (args // rec {
    name = args.name or "cataclysm-dda-mod-${modName}-${version}";

    isTiles = true;
    isConsole = true;

    modRoot = args.modRoot or modName;

    configurePhase = args.configurePhase or ":";
    buildPhase = args.buildPhase or ":";

    installPhase = args.installPhase or ''
      runHook preInstall

      destdir="$out/share/cataclysm-dda/mods"
      mkdir -p "$destdir"
      cp -R "${modRoot}" "$destdir"/

      runHook postInstall
    '';
  });

  # Define a soundpack package.
  buildCDDASoundPack = { soundPackName, version, src, ... } @ args:
  stdenv.mkDerivation (args // rec {
    name = args.name or "cataclysm-dda-soundpack-${soundPackName}-${version}";

    isTiles = true;
    isConsole = false;

    soundPackRoot = args.soundPackRoot or soundPackName;

    configurePhase = args.configurePhase or ":";
    buildPhase = args.buildPhase or ":";

    installPhase = args.installPhase or ''
      runHook preInstall

      destdir="$out/share/cataclysm-dda/sound"
      mkdir -p "$destdir"
      cp -R "${soundPackRoot}" "$destdir"/

      runHook postInstall
    '';
  });
}
