{
  inputs,
  config,
  pkgs,
  ...
}: {
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "met"
      "esphome"
      "dsmr"
      "foscam"
      "tuya"
    ];

    extraPackages = ps:
      with ps; [
        gtts
        websockets
      ];

    customComponents = [
      (pkgs.callPackage ./components/pyloxone.nix {
        input = inputs.hass-pyloxone;
      })
    ];

    config = {
      default_config = {};

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
        ];
      };

      homeassistant = {
        name = "Home";
        time_zone = "Europe/Brussels";
        temperature_unit = "C";
        unit_system = "metric";
      };
    };
  };

  services.nginx.virtualHosts."assistant.bddvlpr.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = let
        inherit (config.services.home-assistant.config.http) server_port;
      in "http://127.0.0.1:${toString server_port}/";
      proxyWebsockets = true;
    };
  };
}
