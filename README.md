# A Nixpkgs overlay of Cataclysm DDA mods

## Status

Under development.

## Installation

```sh
cd $SOMEWHERE
git clone https://github.com/mnacamura/nixpkgs-cdda-mods.git
cd ~/.config/nixpkgs/overlays
ln -s $SOMEWHERE/nixpkgs-cdda-mods
```

After that, mods defined in this overlay will be available in `cataclysmDDA.pkgs`.

## Usage

You can install the game with mods as usual:

```nix
cataclysm-dda.withMods (mods: with mods; [
  tileset.UndeadPeople
  soundpack.atmark
])
```

## License

Copyright (c) 2018--2020 Mitsuhiro Nakamura

This software is distributed under the MIT license.
