{ stdenv, lib, symlinkJoin, makeWrapper }:

cdda:

let
  parsedName = builtins.parseDrvName cdda.name;

  wrapper = { mods }:
  if builtins.length mods == 0 then cdda
  else symlinkJoin {
    name = "${cdda.name}-with-mods";

    paths = [ cdda ] ++ mods;

    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      if [ -x $out/bin/cataclysm ]; then
          wrapProgram $out/bin/cataclysm --add-flags "--datadir $out/share/cataclysm-dda/"
      fi
      if [ -x $out/bin/cataclysm-tiles ]; then
          wrapProgram $out/bin/cataclysm-tiles --add-flags "--datadir $out/share/cataclysm-dda/"
      fi
    '';

    passthru.mods = mods;
  };
in
  lib.makeOverridable wrapper
