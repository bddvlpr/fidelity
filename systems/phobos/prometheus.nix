{
  inputs,
  config,
  ...
}: {
  imports = [inputs.srvos.nixosModules.roles-prometheus];

  services.prometheus = {
    enable = true;

    scrapeConfigs = let
      inherit (config.services.prometheus.exporters) node;
    in [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["phobos.cloud.bddvlpr.com:${toString node.port}"];
          }
        ];
      }
    ];
  };
}
