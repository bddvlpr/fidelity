{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      mkTest =
        test:
        pkgs.stdenvNoCC.mkDerivation (
          {
            dontPatch = true;
            dontConfigure = true;
            dontBuild = true;
            dontInstall = true;
            doCheck = true;
          }
          // test
        );

      callPackage = lib.callPackageWith (
        pkgs
        // {
          inherit mkTest;
          self = builtins.path {
            name = "dotfiles";
            path = inputs.self;
          };
        }
      );
    in
    {
      checks = {
        fmt = callPackage ./fmt.nix { };
      };
    };
}
