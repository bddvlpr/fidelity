{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sysc.nginx;
in {
  options.sysc.nginx = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    enableExporter = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;

      commonHttpConfig = let
        realIpsFromList = strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
        fileToList = x: strings.splitString "\n" (builtins.readFile x);
        cfipv4 = fileToList (pkgs.fetchurl {
          url = "https://www.cloudflare.com/ips-v4";
          sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
        });
        cfipv6 = fileToList (pkgs.fetchurl {
          url = "https://www.cloudflare.com/ips-v6";
          sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
        });
      in ''
        ${realIpsFromList cfipv4}
        ${realIpsFromList cfipv6}
        real_ip_header CF-Connecting-IP;
        access_log syslog:server=unix:/dev/log;
      '';

      virtualHosts."localhost" = mkIf cfg.enableExporter {
        locations."/nginx_status".extraConfig = ''
          stub_status on;
          access_log off;
          allow 127.0.0.1;
          allow ::1;
          deny all;
        '';
      };
    };

    services.prometheus.exporters.nginx.enable = mkIf cfg.enableExporter true;

    security.acme = {
      acceptTerms = true;
      defaults.email = "luna@bddvlpr.com";
    };

    networking.firewall.allowedTCPPorts = [443 80];
  };
}
