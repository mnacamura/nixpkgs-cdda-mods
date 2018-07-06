{ callPackage, stdenv }:

{
  wrapCataclysmDDA = callPackage ./wrapper.nix {};

  buildCataclysmDDAMod = { modName, version, src, ... } @ args:
  stdenv.mkDerivation (args // {
    name = args.name or "cataclysm-dda-mod-${modName}-${version}";

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

  buildCataclysmDDASoundPack = { soundPackName, version, src, ... } @ args:
  stdenv.mkDerivation (args // {
    name = args.name or "cataclysm-dda-soundpack-${soundPackName}-${version}";

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
