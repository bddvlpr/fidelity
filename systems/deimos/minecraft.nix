{
  inputs,
  pkgs,
  lib,
  ...
}: let
  mcPkgs = inputs.nix-minecraft.legacyPackages.${pkgs.system};
in {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };

  services.minecraft-servers.servers.modpack = let
    modpack = mcPkgs.fetchPackwizModpack {
      url = "https://raw.githubusercontent.com/bddvlpr/modpack/49f06f56adff1c66bc53d6a90b94c355e9e9a503/pack.toml";
      packHash = "sha256-ULdVNvba4u/f5FzfUw3pRKtkpWC2fSXFnRA9wT3Ih3Q=";
    };
    mcVersion = modpack.manifest.versions.minecraft;
    fabricVersion = modpack.manifest.versions.fabric;
    serverVersion = lib.replaceStrings ["."] ["_"] "fabric-${mcVersion}";
  in {
    enable = true;
    enableReload = true;

    package = mcPkgs.fabricServers.${serverVersion}.override {loaderVersion = fabricVersion;};
    openFirewall = true;
    symlinks = {
      "mods" = "${modpack}/mods";
    };

    whitelist = {
      bddvlpr = "d10d86d1-33ec-405f-b165-d2483dd0d39a";
      Xono312 = "741026cf-954e-43fc-85d4-5521212e06ee";
      Flugstein = "778a6081-f4e7-4ff3-b906-ab8123a10344";
      TriggeredKat = "e2d8edf0-69b0-4c49-8315-2907f571d157";
    };

    serverProperties = {
      white-list = true;
      motd = "vrcsmp";
      max-players = 16;
      spawn-protection = 0;
      difficulty = 3;
    };
  };

  networking.firewall.allowedUDPPorts = [24454]; # Simple voice mod
}
