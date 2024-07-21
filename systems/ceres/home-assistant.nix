{
  virtualisation.oci-containers.containers.home-assistant = {
    volumes = ["home-assistant-config:/config"];
    environment.TZ = "Europe/Brussels";
    image = "ghcr.io/home-assistant/home-assistant:2024.5.3";
    extraOptions = ["--network=host"];
  };

  services.nginx.virtualHosts."assistant.bddvlpr.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8123/";
      proxyWebsockets = true;
    };
  };

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1400;
      to = 1500;
    }
  ];
}
