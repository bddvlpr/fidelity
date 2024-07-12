{...} @ args: {
  flake = {
    nixosModules = import ./nixos args;
    sharedModules = import ./shared args;
  };
}
