# Nixpkgs overlay for Cataclysm: DDA mods, soundpacks, and tilesets

[Cataclysm: Dark Days Ahead](https://cataclysmdda.org) can be played with
numerous mods, soundpacks, and tilesets. Currently, most of them are not
yet provided in the official [nixpkgs](https://github.com/NixOS/nixpkgs).

This nixpkgs overlay is an attempt to improve the situation; it provides
extra mods, soundpacks, and tilesets not available in nixpkgs. It also
provides derivations for the recent experimental builds, making it easier
to try the bleeding edge of Cataclysm: DDA.

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

After that, mods, soundpacks, and tilesets defined in the overlay will be
visible in `cataclysmDDA.pkgs`.

If you'd like to use the overlay without polluting your environment, you can
do something like this:

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

You can install Cataclysm: DDA with mods as explained in
[the manual](https://nixos.org/manual/nixpkgs/unstable/#cataclysm-dark-days-ahead).
Example:

```nix
let
  # `updatePkgs` is required after you applied `override` or `overrideAttrs`
  # to your C:DDA derivation. It fixes some incorrect attributes remaining
  # after overriding.
  myCDDA = with cataclysmDDA; updatePkgs ((git.tiles.override {
    version = "2020-11-03";
    rev = "97896c2bc98aac1d47f94ff92d0f43670365ef5a";
    sha256 = "1qv30g8ahdgrbbp1kalwnn51mfb66a41dqmm0xifgw6r0pf246fk";
  })).overrideAttrs (_: {
    enableParallelBuilding = false;
  });
in
myCDDA.withMods (mods: with mods; [
  tileset.UndeadPeople
  soundpack.Otopack
])
```

### Experimental builds

The latest experimental build (as of the most recent update in this repo) is
available at

```nix
# Tiles build
cataclysmDDA.jenkins.latest.tiles

# Curses build
cataclysmDDA.jenkins.latest.curses
```

Older experimental builds are also available, up to 60 builds from the latest
to older. Example:

```nix
cataclysmDDA.jenkins.b11150.tiles
```

Note that these builds have no pre-built binaries. You need to compile them by
yourself on your machine.

## Development status

As of now, the following mods, soundpacks, and tilesets are available. If you
know any mod, soundpack, or tileset that should be in this overlay, feel free
to make an issue or pull request.

### Mods

- [x] Artyoms' Gun Emporium
- [ ] Artyoms' Gun Emporium - Reloaded
- [ ] EXTENDED_BUILDINGS
- [ ] ZSFIXED_C:DDA Extra Professions & Gears
- [ ] Jury-Rigged Robots
- [ ] Compatible Nimian Manufacture Guns
- [ ] Removes Nether Creatures
- [x] Cataclysm++
- [ ] Cataclysm++ [0.D Stable]
- [ ] BL9
- [ ] Mining Mod
- [ ] Packaging
- [ ] Parks and Rec Building Pack
- [ ] Mutation Changes
- [ ] No Recreationals
- [ ] Whaleys Small Town Building Pack
- [ ] PKs Rebalancing [build > 8098]
- [ ] Oa's Additional Buildings mod
- [ ] Fuji's More Buildings
- [ ] More City Locations
- [ ] No Makeshift Firearms
- [ ] Wintertime Classes
- [ ] Storage Battery Conversions
- [ ] Craft Ammo Magazines & Belt Links
- [ ] Craft Ammo Mags - ERG
- [ ] Dark Days Ahead: Lua
- [ ] Cars to Wrecks
- [ ] Ninja MOD
- [ ] Draco's Dog Mod
- [ ] Big River Building Pack
- [ ] Seedy Spots Building Pack
- [ ] Whaleys Big Ol' Building Pack
- [ ] More Builings & Locations!
- [ ] Bootleg Walkers
- [ ] Beta National Guard Camp, Aggregate's edit
- [ ] No Freeze
- [ ] Gun Cotton
- [ ] Secronom
- [ ] Vampiric Stuff
- [ ] Hydroponics
- [ ] Nechronica Redux
- [ ] No Zombies
- [ ] More Survivor Stuff
- [ ] XEAS
- [ ] Easy CBM Mods
- [ ] Useful Helicopters

### Soundpacks

- [x] Chesthole soundpack
- [x] Chesthole Creative-Commons-compliant soundpack (ChestHoleCC)
- [x] Chesthole Old-Timey Less Is More soundpack (ChestOldTimey)
- [x] RRFSounds
- [ ] 2ch soundpack
- [x] CDDA soundpack
- [x] @'s soundpack
- [ ] CO.AG MusicPack Redux
- [x] Otopack

### Tilesets

- [x] UndeadPeople tileset
- [ ] Mod tilesets shipped with UndeadPeople tileset

## License

This software is distributed under the terms of [the MIT license](./LICENSE).
