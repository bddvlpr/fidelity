{ inputs, ... }:
{
  imports =
    with inputs.srvos.nixosModules;
    [
      server
      mixins-terminfo
    ]
    ++ [
      ./disko.nix
      ./impermanence.nix
    ];
}
