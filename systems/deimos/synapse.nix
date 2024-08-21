{pkgs, ...}: {
  services.matrix-synapse = {
    enable = true;

    configureRedisLocally = true;

    settings = {
      server_name = "bddvlpr.com";
      public_baseurl = "https://matrix.bddvlpr.com";
      enable_metrics = true;
      listeners = [
        {
          bind_addresses = ["::"];
          port = 8008;
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
                "metrics"
              ];
              compress = true;
            }
          ];
        }
      ];
    };
  };

  services.postgresql = {
    enable = true;

    initialScript = pkgs.writeText "init.sql" ''
      CREATE ROLE "matrix-synapse" LOGIN;
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.nginx.virtualHosts."matrix.bddvlpr.com" = {
    enableACME = true;
    forceSSL = true;

    locations = {
      "/".return = "403";
      "/_matrix".proxyPass = "http://[::]:8008";
      "/_synapse/client".proxyPass = "http://[::]:8008";
    };
  };
}
