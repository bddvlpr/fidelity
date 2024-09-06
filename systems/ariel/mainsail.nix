{
  services.mainsail = {
    enable = true;
    nginx.listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];
    nginx.serverAliases = ["mainsail.local"];
  };

  networking.firewall.allowedTCPPorts = [80];
}
