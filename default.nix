self: super:

let
  pkgs = self.callPackage ./pkgs {
    oldPkgs = super.cataclysmDDA.pkgs;
  };

  commonOverrideArgs = {
  };

  commonOverrideAttrsArgs = old: {
    enableParallelBuilding = true;
  };

  attachPkgs = pkgs: build:
  let
    this = build.overrideAttrs (old: {
      passthru = old.passthru // {
        pkgs = pkgs.override { build = this; };
        withMods = self.cataclysmDDA.wrapCDDA this;
      };
    });
  in
  this;

  applyOverrides = build:
  with self.cataclysmDDA;
  attachPkgs pkgs ((build.override commonOverrideArgs).overrideAttrs commonOverrideAttrsArgs);

  jenkins = self.callPackage ./jenkins.nix {};
in

{
  cataclysmDDA = super.cataclysmDDA // {
    inherit pkgs jenkins;

    # Required to fix `pkgs` and `withMods` attrs after applying `override` or `overrideAttrs`.
    # Example:
    # let
    #   myBuild = cataclysmDDA.jenkins.latest.tiles.overrideAttrs (_: {
    #     x = "hello";
    #   });
    #
    #   # This refers to the derivation before overriding! So, `badExample.x` is not accessible.
    #   badExample = myBuild.withMods (_: []);
    # 
    #   # `myBuild` is correctly referred by `withMods` and `goodExample.x` is accessible.
    #   goodExample = let
    #     inherit (cataclysmDDA) attachPkgs pkgs;
    #   in
    #   (attachPkgs pkgs myBuild).withMods (_: []);
    # in
    # goodExample.x  # returns "hello"
    inherit attachPkgs;

    stable = self.lib.mapAttrs (_: applyOverrides) super.cataclysmDDA.stable;

    git = self.lib.mapAttrs (_: applyOverrides) super.cataclysmDDA.git;
  };
}
