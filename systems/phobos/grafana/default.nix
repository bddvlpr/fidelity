{
  config,
  lib,
  outputs,
  ...
}:
with lib; {
  sops.secrets = let
    owner = "grafana";
  in {
    "grafana/email" = {inherit owner;};
    "grafana/user" = {inherit owner;};
    "grafana/password" = {inherit owner;};
  };

  services.grafana = {
    enable = true;

    settings = {
      server.root_url = "https://monitoring.bddvlpr.cloud";

      security = {
        admin_email = "$__file{${config.sops.secrets."grafana/email".path}}";
        admin_user = "$__file{${config.sops.secrets."grafana/user".path}}";
        admin_password = "$__file{${config.sops.secrets."grafana/password".path}}";
      };
    };

    provision = {
      enable = true;

      dashboards.settings = {
        providers = [
          {
            name = "Node Exporter";
            type = "file";
            options.path = ./dashboards/node-exporter.json;
          }
          {
            name = "NGINX Exporter";
            type = "file";
            options.path = ./dashboards/nginx-exporter.json;
          }
          {
            name = "Synapse Exporter";
            type = "file";
            options.path = ./dashboards/synapse-exporter.json;
          }
        ];
      };

      datasources.settings = {
        apiVersion = 1;

        datasources = let
          prometheusHosts = filter (host: host != config.networking.hostName) (lib.mapAttrsToList (host: nixosConfig: "${host}.host.bddvlpr.cloud:9090") (filterAttrs (host: nixosConfig: nixosConfig.config.services.prometheus.enable or false) outputs.nixosConfigurations));
        in
          map (host: {
            name = lib.strings.removeSuffix ":9090" host;
            type = "prometheus";
            url = "http://${host}";
          })
          prometheusHosts;
      };
    };
  };

  services.nginx.virtualHosts."monitoring.bddvlpr.cloud" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = let
      inherit (config.services.grafana.settings.server) http_port;
    in "http://127.0.0.1:${toString http_port}/";
  };
}
