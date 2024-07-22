{config, ...}: let
  hostname = "frigate.local";
in {
  sops.secrets."frigate/auth" = {owner = "nginx";};
  sops.secrets."frigate/secrets" = {owner = "frigate";};

  systemd.services.frigate.serviceConfig = {
    EnvironmentFile = config.sops.secrets."frigate/secrets".path;
  };

  services.frigate = {
    enable = true;
    inherit hostname;

    settings = {
      cameras = {
        garage = {
          ffmpeg.inputs = [
            {
              path = "rtsp://{FRIGATE_GARAGE_USER}:{FRIGATE_GARAGE_PASS}@{FRIGATE_GARAGE_IP}/{FRIGATE_GARAGE_PATH}";
              roles = ["detect"];
            }
          ];
        };

        garden = {
          ffmpeg.inputs = [
            {
              path = "rtsp://{FRIGATE_GARDEN_USER}:{FRIGATE_GARDEN_PASS}@{FRIGATE_GARDEN_IP}/{FRIGATE_GARDEN_PATH}";
              roles = ["detect"];
            }
          ];
        };

        living = {
          ffmpeg.inputs = [
            {
              path = "rtsp://{FRIGATE_LIVING_USER}:{FRIGATE_LIVING_PASS}@{FRIGATE_LIVING_IP}/{FRIGATE_LIVING_PATH}";
              roles = ["detect"];
            }
          ];
        };
      };
    };
  };

  services.nginx.virtualHosts.${hostname} = {
    forceSSL = true;
    enableACME = true;

    locations."/".basicAuthFile = config.sops.secrets."frigate/auth".path;
  };
}
