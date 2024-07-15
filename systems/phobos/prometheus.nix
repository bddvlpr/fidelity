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
              "phobos.cloud.bddvlpr.com"
            ];
          }
        ];
      }
    ];
  };
}
