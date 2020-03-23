{ lib, cataclysmDDAPackages, symlinkJoin, makeWrapper }:

unwrapped:

with cataclysmDDAPackages;

let
  inherit (lib) filter makeOverridable;

  wrapper = { packages, ... } @ args:
  let
    unwrapped' = unwrapped.override (builtins.removeAttrs args [ "packages" ]);
    packages' = if isTiles unwrapped'
    then filter (pkg: pkg.forTiles) packages
    else filter (pkg: pkg.forConsole) packages;
  in
  if builtins.length packages' == 0 then unwrapped'
  else symlinkJoin {
    name = unwrapped'.name + "-with-mods";
    paths = [ unwrapped' ] ++ packages';
    nativeBuildInputs = [ makeWrapper ];
    postBuild = ''
      if [ -x $out/bin/cataclysm ]; then
          wrapProgram $out/bin/cataclysm \
              --add-flags "--datadir $out/share/cataclysm-dda/"
      fi
      if [ -x $out/bin/cataclysm-tiles ]; then
          wrapProgram $out/bin/cataclysm-tiles \
              --add-flags "--datadir $out/share/cataclysm-dda/"
      fi
    '';
    passthru.packages = packages';
  };
in

makeOverridable wrapper
