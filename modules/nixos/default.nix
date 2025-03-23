{ inputs, ... }:
{
  imports =
    with inputs.srvos.nixosModules;
    [
      server
      mixins-terminfo
    ]
    ++ [
      ./boot.nix
      ./disko.nix
    ];
}
