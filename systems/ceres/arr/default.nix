{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.nixarr.nixosModules.default ];

  sops.secrets."mullvad/conf".owner = config.services.transmission.user;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  nixarr = {
    enable = true;

    mediaDir = "/mnt/media";

    vpn = {
      enable = true;
      wgConf = config.sops.secrets."mullvad/conf".path;
    };

    jellyfin.enable = true;
    jellyseerr.enable = true;

    transmission = {
      enable = true;
      flood.enable = true;
      openFirewall = true;
      extraSettings = {
        rpc-enabled = true;
        rpc-host-whitelist = "ceres";

        dht-enabled = false;
        lpd-enabled = false;
        pex-enabled = false;
      };
      vpn.enable = true;
    };

    prowlarr.enable = true;
    bazarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
  };

  services.nginx.virtualHosts."media.bddvlpr.cloud" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096/";
      proxyWebsockets = true;
    };
  };
}
