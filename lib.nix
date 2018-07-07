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
  stdenv.mkDerivation (args // {
    name = args.name or "cataclysm-dda-mod-${modName}-${version}";

    isTiles = true;
    isConsole = true;

    configurePhase = args.configurePhase or ''
      runHook preConfigure
      # noop
      runHook postConfigure
    '';

    buildPhase = args.buildPhase or ''
      runHook prebuild
      # noop
      runHook postbuild
    '';

    checkPhase = args.checkPhase or ''
      runHook preCheck
      echo "Checking mod"
      # check something
      runHook postCheck
    '';

    doCheck = args.doCheck or true;

    installPhase = args.installPhase or ''
      runHook preInstall
      dest=$out/share/cataclysm-dda/mods/${modName}
      for file in $(find . -type f -not -name '*.nix'); do
          install -D -m 444 $file -T $(echo $file | sed "s,.,$dest,")
      done
      runHook postInstall
    '';
  });

  # Define a soundpack package.
  buildCDDASoundPack = { soundPackName, version, src, ... } @ args:
  stdenv.mkDerivation (args // {
    name = args.name or "cataclysm-dda-soundpack-${soundPackName}-${version}";

    isTiles = true;
    isConsole = false;

    configurePhase = ":";
    buildPhase = ":";
    checkPhase = ":";

    installPhase = args.installPhase or ''
      runHook preInstall
      dest="$out/share/cataclysm-dda/sound"
      mkdir -p "$dest"
      cp -R ${soundPackName} "$dest"/
      runHook postInstall
    '';
  });
}
