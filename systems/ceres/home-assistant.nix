{
  inputs,
  config,
  pkgs,
  lib,
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
      "isal"
      "homekit"
      "shelly"
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

      automation = lib.flatten (builtins.map (act: [
          {
            alias = "Geolocation/${act.user} enters home";
            trigger = [
              {
                platform = "zone";
                entity_id = act.user;
                zone = "zone.home";
                event = "enter";
              }
            ];
            action = [
              {
                action = "switch.turn_on";
                target.entity_id = act.target;
              }
            ];
          }
          {
            alias = "Geolocation/${act.user} leaves home";
            trigger = [
              {
                platform = "zone";
                entity_id = act.user;
                zone = "zone.home";
                event = "leave";
              }
            ];
            action = [
              {
                action = "switch.turn_off";
                target.entity_id = act.target;
              }
            ];
          }
        ]) [
          {
            user = "person.bddvlpr";
            target = "switch.stijnifttt";
          }
          {
            user = "person.sven";
            target = "switch.svenifttt";
          }
          {
            user = "person.cin";
            target = "switch.cinifttt";
          }
          {
            user = "person.anke";
            target = "switch.ankeifttt";
          }
        ]);
    };
  };

  networking.firewall = {
    allowedTCPPorts = [21064];
    allowedUDPPorts = [5353];
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
