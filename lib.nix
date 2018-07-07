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

    configurePhase = ":";
    buildPhase = ":";
    checkPhase = ":";

    outputs = [ "out" "doc" ];

    installPhase = args.installPhase or ''
      runHook preInstall

      mods="$out/share/cataclysm-dda/mods"
      mkdir -p "$mods"
      cp -R ${modName} "$mods"/

      doc="$doc/share/doc/cataclysm-dda/mods/${modName}"
      mkdir -p "$doc"
      # Guess documents
      for file in $(find . -maxdepth 1 -type f -iregex '.*readme.*' -or -name '*.{md,txt}')
      do
          cp "$file" "$doc"/
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

    outputs = [ "out" "doc" ];

    installPhase = args.installPhase or ''
      runHook preInstall

      sound="$out/share/cataclysm-dda/sound"
      mkdir -p "$sound"
      cp -R ${soundPackName} "$sound"/

      doc="$doc/share/doc/cataclysm-dda/sound/${modName}"
      mkdir -p "$doc"
      # Guess documents
      for file in $(find . -maxdepth 1 -type f -iregex '.*readme.*' -or -name '*.{md,txt}')
      do
          cp "$file" "$doc"/
      done

      runHook postInstall
    '';
  });
}
