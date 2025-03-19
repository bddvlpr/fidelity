{
  services.moonraker = {
    enable = true;

    settings = {
      authorization = {
        cors_domains = [
          "*.bddvlpr.com"
          "*.local"
          "*.lan"
          "*://app.fluidd.xyz"
          "*://my.mainsail.xyz"
        ];

        trusted_clients = [
          # "10.0.0.0/8"
          # "127.0.0.0/8"
          # "169.254.0.0/16"
          # "172.16.0.0/12"
          "192.168.14.0/24"
          "100.64.0.0/10" # Tailscale
          "FE80::/10"
          "::1/128"
        ];
      };
      octoprint_compat = { };
      history = { };

      "webcam printer" = {
        target_fps = 5;
        target_fps_idle = 5;
        stream_url = "/webcam/stream";
        snapshot_url = "/webcam/snapshot";
      };
    };
  };
}
