{config, ...}: {
  sops.secrets."alertmanager/auth" = {owner = "nginx";};
  sops.secrets."alertmanager/env" = {};

  services.prometheus.alertmanager = {
    enable = true;
    webExternalUrl = "https://monitoring.bddvlpr.com/alertmanager/";
    extraFlags = ["--cluster.listen-address=''" "--web.route-prefix=/"];

    environmentFile = config.sops.secrets."alertmanager/env".path;

    configuration = {
      global = {
        smtp_smarthost = "smtp.mailbox.org:587";
        smtp_from = "$SMTP_FROM";
        smtp_require_tls = true;
        smtp_auth_username = "$SMTP_USERNAME";
        smtp_auth_password = "$SMTP_PASSWORD";
      };

      route = {
        receiver = "cloud.bddvlpr.com";
        group_wait = "30s";
        group_interval = "5m";
        repeat_interval = "1h";
        group_by = ["host"];
      };

      receivers = [
        {
          name = "cloud.bddvlpr.com";
          email_configs = [
            {to = "luna@bddvlpr.com";}
          ];
        }
      ];
    };
  };

  services.prometheus.alertmanagers = [
    {
      static_configs = [
        {
          targets = let
            inherit (config.services.prometheus.alertmanager) port;
          in ["localhost:${toString port}"];
        }
      ];
    }
  ];

  services.nginx.virtualHosts."monitoring.bddvlpr.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/alertmanager/" = {
      proxyPass = let
        inherit (config.services.prometheus.alertmanager) port;
      in "http://127.0.0.1:${toString port}/";
      basicAuthFile = config.sops.secrets."alertmanager/auth".path;
    };
  };
}
