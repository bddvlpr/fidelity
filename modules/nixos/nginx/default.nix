{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sysc.nginx;
in {
  options.sysc.nginx = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    enableExporter = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;

      commonHttpConfig = let
        realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
        fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
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
    };

    services.prometheus.exporters.nginx.enable = lib.mkIf cfg.enableExporter true;

    security.acme = {
      acceptTerms = true;
      defaults.email = "luna@bddvlpr.com";
    };

    networking.firewall.allowedTCPPorts = [443 80];
  };
}
