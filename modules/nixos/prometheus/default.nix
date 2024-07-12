{config, ...}: {
  services.prometheus = {
    enable = true;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
      };
    };

    scrapeConfigs = let
      inherit (config.services.prometheus) exporters;
    in [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString exporters.node.port}"];
          }
        ];
      }
    ];
  };
}
