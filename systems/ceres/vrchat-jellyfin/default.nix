{config, ...}: {
  sops.secrets = {
    "vrchat-jellyfin/env" = {};
    "vrchat-jellyfin/htaccess" = {owner = "nginx";};
  };

  virtualisation.oci-containers.containers.vrchat-jellyfin = {
    image = let
      hash = "88104512748a403ed1b6ef398af7a31a292f039234ed53e1d1cb180f44e4f204";
    in "ghcr.io/gurrrrrrett3/vrchat-jellyfin@sha256:${hash}";
    ports = ["4000:4000"];
    environment = {
      MAX_WIDTH = "1280";
      MAX_HEIGHT = "720";

      AUDIO_BITRATE = "128000";
      VIDEO_BITRATE = "3000000";
      MAX_AUDIO_CHANNELS = "2";
    };
    environmentFiles = [
      config.sops.secrets."vrchat-jellyfin/env".path
    ];
  };

  services.nginx.virtualHosts."media.bddvlpr.cloud" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:4000/";
        proxyWebsockets = true;
        extraConfig = ''
          auth_basic "restricted";
          auth_basic_user_file ${config.sops.secrets."vrchat-jellyfin/htaccess".path};
        '';
      };
      "/v/" = {
        proxyPass = "http://127.0.0.1:4000/v/";
        proxyWebsockets = true;
        extraConfig = ''
          auth_basic off;
        '';
      };
    };
  };
}
