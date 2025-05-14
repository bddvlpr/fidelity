{
  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server@sha256:5396fc565543181c24a0ab89074f93e85b8eb83f6f1f193fb39a61c6014ae5c2";
    ports = ["5006:5006"];
    volumes = [
      "actual-data:/data"
    ];
  };

  services.nginx.virtualHosts."actual.bddvlpr.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5006/";
      proxyWebsockets = true;
    };
  };
}
