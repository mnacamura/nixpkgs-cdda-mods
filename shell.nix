let
  nixpkgs = fetchNixpkgs {
    rev = "0da76dab4c2acce5ebf404c400d38ad95c52b152";
    sha256 = "1lj3h4hg3cnxl3avbg9089wd8c82i6sxhdyxfy99l950i78j0gfg";
  };

  fetchNixpkgs = { rev, sha256 }:
  builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in

with import nixpkgs {};

mkShell {
  buildInputs = [ gauche git ];

  GAUCHE_LOAD_PATH = "./lib";
}
