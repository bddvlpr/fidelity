{
  lib,
  config,
  outputs,
  ...
}:
with lib; let
  cfg = config.sysc.prometheus;
in {
  options.sysc.prometheus = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      retentionTime = "31d";

      ruleFiles = [
        ./rules/node-exporter.yml
        ./rules/prometheus-exporter.yml
      ];

      scrapeConfigs =
        (
          let
            ignoredExporters = ["minio" "unifi-poller" "tor"];
          in
            builtins.filter (v: let static_configs = builtins.head v.static_configs; in static_configs.targets != []) (mapAttrsToList (
              name: value: {
                job_name = name;
                static_configs = let
                  hosts = filterAttrs (host: nixosConfig: nixosConfig.config.services.prometheus.exporters.${name}.enable or false) outputs.nixosConfigurations;
                in [
                  {
                    targets = lib.mapAttrsToList (host: nixosConfig: "${host}.host.bddvlpr.cloud:${toString value.port}") hosts;
                  }
                ];
              }
            ) (filterAttrs (name: value: !(builtins.elem name ignoredExporters)) config.services.prometheus.exporters))
        )
        ++ [
          {
            job_name = "synapse";
            metrics_path = "/_synapse/metrics";
            static_configs = [
              {
                targets = ["deimos.host.bddvlpr.cloud:8008"];
              }
            ];
          }
        ];

      alertmanagers = let
        alertmanagerConfigs = filterAttrs (host: nixosConfig: nixosConfig.config.services.prometheus.alertmanager.enable or false) outputs.nixosConfigurations;
      in [
        {
          static_configs = [
            {
              targets = mapAttrsToList (host: nixosConfig: let
                inherit (nixosConfig.config.services.prometheus.alertmanager) port;
              in "${host}.host.bddvlpr.cloud:${toString port}")
              alertmanagerConfigs;
            }
          ];
        }
      ];
    };
  };
}
