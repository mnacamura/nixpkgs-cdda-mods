# A Nixpkgs overlay of Cataclysm DDA mods, soundpacks, and tilesets

[Cataclysm: Dark Days Ahead](https://cataclysmdda.org) can be played with
numerous mods, soundpacks, and tilesets. At the moment, most of them are not
yet provided in [nixpkgs](https://github.com/NixOS/nixpkgs).

This nixpkgs overlay is an attempt to improve the situation; it provides
extra mods, soundpacks, and tilesets not available in the upstream nixpkgs.

## Status

If you know any mod, soundpack, or tileset that should be available in this
overlay, feel free to make an issue or pull request.

### Mods

### Soundpacks

- [ ] CO.AG MusicPack
- [x] Otopack
- [x] @'s soundpack
- [x] budg3's soundpack (CDDA-Soundpack)
- [x] Chesthole Soundpack
- [ ] Chesthole Resident Evil 4 Soundpack (ChestHoleRE4)
- [x] Chesthole Creative-Commons-compliant Soundpack (ChestHoleCC)
- [x] Chesthole Old-Timey Less Is More Soundpack (ChestOldTimey)
- [x] RRF Soundpack
- [ ] 2ch Soundpack

### Tilesets

## Installation

See [the manual](https://nixos.org/manual/nixpkgs/unstable/#sec-overlays-install)
to install nixpkgs overlays in general. You can install this overlay under
your `~/.config/nixpkgs` for example:

```sh
cd $SOMEWHERE
git clone https://github.com/mnacamura/nixpkgs-cdda-mods.git
cd ~/.config/nixpkgs/overlays
ln -s $SOMEWHERE/nixpkgs-cdda-mods
```

After that, mods defined in the overlay will be available in
`cataclysmDDA.pkgs`.

If you like to use the overlay without polluting your environment, you can do
something like this:

```nix
let
  nixpkgs-cdda-mods = builtins.fetchTarball {
    url = "https://github.com/mnacamura/nixpkgs-cdda-mods/archive/master.tar.gz";
  };
in

with import <nixpkgs> {
  overlays = [ (import nixpkgs-cdda-mods) ];
};

...
```


## Usage

You can install Cataclysm DDA with mods as  explained in
[the manual](https://nixos.org/manual/nixpkgs/unstable/#cataclysm-dark-days-ahead).
Example:

```nix
((cataclysmDDA.git.tiles.override {
  version = "2020-11-03";
  rev = "97896c2bc98aac1d47f94ff92d0f43670365ef5a";
  sha256 = "1qv30g8ahdgrbbp1kalwnn51mfb66a41dqmm0xifgw6r0pf246fk";
}).overrideAttrs (_: {
  enableParallelBuilding = true;
})).withMods (mods: with mods; [
  tileset.UndeadPeople
  soundpack.Otopack
])
```

## License

Copyright (c) 2018--2020 Mitsuhiro Nakamura

This software is distributed under the MIT license.
