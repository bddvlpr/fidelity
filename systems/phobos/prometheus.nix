{
  config,
  pkgs,
  ...
}: {
  services.prometheus = {
    enable = true;

    retentionTime = "31d";

    ruleFiles = [
      ./rules/node-exporter.yml
      ./rules/prometheus-exporter.yml
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
      {
        job_name = "blackbox";
        metrics_path = "/probe";
        scrape_interval = "30s";
        scheme = "https";
        file_sd_configs = [
          {
            files = [
              (toString (pkgs.writeText "blackbox-config.yml" ''
                - targets:
                    - screeb-probe-montreal.cleverapps.io:_:http_2xx:_:Montreal:_:f229cy:_:https://api.screeb.app
                    - screeb-probe-montreal.cleverapps.io:_:http_2xx:_:Montreal:_:f229cy:_:https://t.screeb.app/tag.js
                    - screeb-probe-montreal.cleverapps.io:_:icmp_ipv4:_:Montreal:_:f229cy:_:api.screeb.app
                    - screeb-probe-montreal.cleverapps.io:_:icmp_ipv4:_:Montreal:_:f229cy:_:t.screeb.app

                    - screeb-probe-paris.cleverapps.io:_:http_2xx:_:Paris:_:u09tgy:_:https://api.screeb.app
                    - screeb-probe-paris.cleverapps.io:_:http_2xx:_:Paris:_:u09tgy:_:https://t.screeb.app/tag.js
                    - screeb-probe-paris.cleverapps.io:_:icmp_ipv4:_:Paris:_:u09tgy:_:api.screeb.app
                    - screeb-probe-paris.cleverapps.io:_:icmp_ipv4:_:Paris:_:u09tgy:_:t.screeb.app

                    - screeb-probe-warsaw.cleverapps.io:_:http_2xx:_:Warsaw:_:u3qcnm:_:https://api.screeb.app
                    - screeb-probe-warsaw.cleverapps.io:_:http_2xx:_:Warsaw:_:u3qcnm:_:https://t.screeb.app/tag.js
                    - screeb-probe-warsaw.cleverapps.io:_:icmp_ipv4:_:Warsaw:_:u3qcnm:_:api.screeb.app
                    - screeb-probe-warsaw.cleverapps.io:_:icmp_ipv4:_:Warsaw:_:u3qcnm:_:t.screeb.app
              ''))
            ];
          }
        ];
        relabel_configs = [
          {
            source_labels = ["__address__"];
            regex = ".*:_:(.*):_:.*:_:.*:_:.*";
            target_label = "module";
          }
          {
            source_labels = ["__address__"];
            regex = ".*:_:.*:_:.*:_:(.*):_:.*";
            target_label = "geohash";
          }
          {
            source_labels = ["__address__"];
            regex = ".*:_:.*:_:.*:_:.*:_:(.*)";
            target_label = "instance";
          }
          {
            source_labels = ["__address__"];
            regex = ".*:_:.*:_:(.*):_:.*:_:.*";
            target_label = "pop";
          }
          {
            source_labels = ["module"];
            target_label = "__param_module";
          }
          {
            source_labels = ["instance"];
            target_label = "__param_target";
          }
          {
            source_labels = ["__address__"];
            regex = "(.*):_:.*:_:.*:_:.*:_:.*";
            target_label = "__address__";
          }
        ];
      }
    ];
  };
}
