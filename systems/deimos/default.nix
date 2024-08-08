{inputs, ...}: {
  imports =
    [
      ./minecraft.nix
    ]
    ++ (with inputs.srvos.nixosModules; [
      mixins-terminfo
    ]);

  networking = {
    hostName = "deimos";
    hostId = "3d845e22";

    interfaces.enp7s0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.3";
          prefixLength = 16;
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
