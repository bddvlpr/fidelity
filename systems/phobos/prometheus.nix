{
  lib,
  outputs,
  config,
  ...
}: {
  services.prometheus = {
    enable = true;

    retentionTime = "31d";

    ruleFiles = [
      ./rules/node-exporter.yml
      ./rules/prometheus-exporter.yml
    ];

    scrapeConfigs =
      (let
        ignoredExporters = ["minio" "unifi-poller"];
        exporters = config.services.prometheus.exporters;
      in
        builtins.filter (v: let static_configs = builtins.head v.static_configs; in static_configs.targets != []) (lib.mapAttrsToList (
            name: value: {
              job_name = name;
              static_configs = let
                hosts = lib.filterAttrs (host: nixosConfig: nixosConfig.config.services.prometheus.exporters.${name}.enable or false) outputs.nixosConfigurations;
              in [
                {
                  targets = lib.mapAttrsToList (host: nixosConfig: "${host}.cloud.bddvlpr.com:${toString value.port}") hosts;
                }
              ];
            }
          )
          (lib.filterAttrs (name: value: !(builtins.elem name ignoredExporters)) exporters)))
      ++ [
        # {
        #   job_name = "fabric";
        #   static_configs = [
        #     {
        #       targets = ["deimos.cloud.bddvlpr.com:25585"];
        #     }
        #   ];
        # }
        {
          job_name = "synapse";
          metrics_path = "/_synapse/metrics";
          static_configs = [
            {
              targets = ["deimos.cloud.bddvlpr.com:8008"];
            }
          ];
        }
      ];
  };
}
