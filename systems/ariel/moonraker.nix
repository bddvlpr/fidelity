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
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.1.0/24"
          "FE80::/10"
          "::1/128"
        ];
      };
      octoprint_compat = {};
      history = {};
    };
  };
}
