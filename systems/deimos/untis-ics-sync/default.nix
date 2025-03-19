{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.untis-ics-sync.nixosModules.default
  ];

  sops = {
    secrets = {
      "uis/schoolname" = { };
      "uis/username" = { };
      "uis/password" = { };
      "uis/baseurl" = { };
    };

    templates."untis-ics-sync.env".content =
      let
        inherit (config.sops) placeholder;
      in
      ''
        UNTIS_SCHOOLNAME=${placeholder."uis/schoolname"}
        UNTIS_USERNAME=${placeholder."uis/username"}
        UNTIS_PASSWORD=${placeholder."uis/password"}
        UNTIS_BASEURL=${placeholder."uis/baseurl"}

        CORS_ORIGIN="https://uis-ap.bddvlpr.com"

        LESSONS_TIMETABLE_BEFORE=3
        LESSONS_TIMETABLE_AFTER=14
      '';
  };

  services.untis-ics-sync = {
    enable = true;
    envFile = config.sops.templates."untis-ics-sync.env".path;
  };

  services.nginx.virtualHosts."uis-ap-srv.bddvlpr.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://[::]:3000/";
  };
}
