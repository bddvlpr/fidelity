{config, ...}: {
  services.prometheus = {
    enable = true;

    retentionTime = "31d";

    ruleFiles = [
      ./rules/node-exporter.yml
    ];

    scrapeConfigs = let
      inherit (config.services.prometheus.exporters) node;
    in [
      {
        job_name = "node";
        static_configs = [
          {
            targets = map (host: "${host}:${toString node.port}") [
              "ceres.cloud.bddvlpr.com"
              "phobos.cloud.bddvlpr.com"
            ];
          }
        ];
      }
    ];
  };
}
