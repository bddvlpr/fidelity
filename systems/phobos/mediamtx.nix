{
  services.mediamtx = {
    enable = true;
    settings = {
      logLevel = "info";
      logDestinations = ["stdout" "syslog"];

      authMethod = "internal";
      authInternalUsers = [
        {
          user = "any";
          pass = "";
          ips = [];
          permissions = [{action = "read";} {action = "publish";}];
        }
      ];

      hlsAlwaysRemux = true;
      hlsVariant = "mpegts";
      hlsSegmentDuration = "500ms";
      hlsSegmentCount = 14;

      paths = {
        all_others = {
          source = "publisher";
        };
      };
    };
  };

  services.nginx.virtualHosts."tx.bddvlpr.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:8888";
  };

  networking.firewall.allowedTCPPorts = [1935];
}
