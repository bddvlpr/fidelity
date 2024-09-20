{
  services.mainsail = {
    enable = true;
    nginx.listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];
    nginx.serverAliases = ["printer.bddvlpr.com"];
  };

  networking.firewall.allowedTCPPorts = [80];
}
