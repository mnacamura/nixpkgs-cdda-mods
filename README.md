# A Nixpkgs overlay of Cataclysm DDA mods and soundpacks

## Status

Under development.

## Installation

```sh
cd $SOMEWHERE
git clone https://github.com/mnacamura/nixpkgs-cdda-mods.git
cd ~/.config/nixpkgs/overlays
ln -s $SOMEWHERE/nixpkgs-cdda-mods
```

Then, you can customize the derivation of Cataclysm DDA:

```nix
cataclysm-dda-git-console.override {
  packages = with cataclysmDDAPackages; [ mod.Ninja ];
}
```

## License

Copyright (c) 2018 Mitsuhiro Nakamura

This software is distributed under the MIT license.
