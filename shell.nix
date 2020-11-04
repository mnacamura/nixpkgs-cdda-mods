with import <nixpkgs> {};

mkShell {
  buildInputs = [ gauche ];

  GAUCHE_READ_EDIT = true;
}
