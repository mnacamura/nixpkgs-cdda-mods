{ lib, fetchFromGitHub, cataclysmDDA
, version ? "891"
, rev ? "dd73e8e5c48a2ba109556cc800be924a44dd0e79"
, sha256 ? "13lnp0gx037b16qccpkiffma2835xa7hmsf549l8dny1xq6j817x"
}:

rec {
  tiles = (cataclysmDDA.git.tiles.override {
    inherit version rev sha256;
  }).overrideAttrs (old: rec {
    pname = "cataclysm-bn";
    src = fetchFromGitHub {
      owner = "cataclysmbnteam";
      repo = "Cataclysm-BN";
      inherit rev sha256;
    };
    makeFlags = old.makeFlags ++ [
      "VERSION=release-${version}-${lib.substring 0 8 src.rev}"
    ];
    meta = old.meta // {
      description = "Cataclysm: Bright Nights, a fork/variant of Cataclysm: DDA";
      longDescription = null;
      homepage = "https://github.com/cataclysmbnteam/Cataclysm-BN";
    };
  });

  curses = tiles.override { tiles = false; };
}
