{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "nextcloud/smtphost" = {};
    "nextcloud/smtpport" = {};
    "nextcloud/smtpname" = {};
    "nextcloud/smtppassword" = {};
    "nextcloud/adminpass" = {owner = "nextcloud";};
  };
  sops.templates."nextcloud-secrets.json" = {
    owner = "nextcloud";
    content = let
      inherit (config.sops) placeholder;
    in ''
      {
        "mail_from_address": "cloud",
        "mail_domain": "bddvlpr.com",
        "mail_smtpauth": 1,
        "mail_smtphost": "${placeholder."nextcloud/smtphost"}",
        "mail_smtpport": "${placeholder."nextcloud/smtpport"}",
        "mail_smtpsecure": "tls",
        "mail_smtpname": "${placeholder."nextcloud/smtpname"}",
        "mail_smtppassword": "${placeholder."nextcloud/smtppassword"}"
      }
    '';
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.bddvlpr.com";
    package = pkgs.nextcloud30;

    https = true;
    database.createLocally = true;
    configureRedis = true;

    phpOptions."opcache.interned_strings_buffer" = "16";

    config = {
      dbtype = "pgsql";
      adminuser = "bddvlpr";
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    };

    secretFile = config.sops.templates."nextcloud-secrets.json".path;

    settings = {
      default_phone_region = "BE";
      default_timezone = "Europe/Brussels";
      maintenance_window_start = 2;
    };

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar contacts mail notes;
    };
  };

  services.nginx.virtualHosts."cloud.bddvlpr.com" = {
    forceSSL = true;
    enableACME = true;
  };
}
