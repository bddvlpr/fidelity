{config, ...}: {
  sops.secrets."tailscale/key" = {};

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."tailscale/key".path;
  };
}
