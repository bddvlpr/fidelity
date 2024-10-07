{pkgs, ...}: {
  services.mainsail = {
    enable = true;
    nginx = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      serverAliases = ["printer.bddvlpr.com"];
      locations."/webcam/".proxyPass = "http://127.0.0.1:8584/";
      locations."/spoolman/".proxyPass = "http://127.0.0.1:8585/";
    };
  };

  systemd.services.klippercam = {
    enable = true;
    script = "${pkgs.ustreamer}/bin/ustreamer -f 5 -p 8584";
    after = ["network.target"];
  };

  networking.firewall.allowedTCPPorts = [80];
}
