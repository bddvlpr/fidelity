let
  hostname = "frigate.bddvlpr.com";
in {
  sops.secrets."frigate/garage-path" = {owner = "frigate";};

  services.frigate = {
    enable = true;
    inherit hostname;

    settings = {
      cameras = {
        garage = {
          ffmpeg.inputs = [
            {
              roles = ["detect"];
            }
          ];
        };

        garden = {
          ffmpeg.inputs = [
            {
              roles = ["detect"];
            }
          ];
        };

        living = {
          ffmpeg.inputs = [
            {
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
  };
}
