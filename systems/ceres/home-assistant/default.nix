{
  inputs,
  config,
  pkgs,
  lib,
  ...
} @ args: {
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "apple_tv"
      "cast"
      "dsmr"
      "elevenlabs"
      "esphome"
      "foscam"
      "homekit"
      "isal"
      "met"
      "motion_blinds"
      "roomba"
      "shelly"
      "sonos"
      "tuya"
    ];

    extraPackages = ps:
      with ps; [
        gtts
        websockets

        # Homekit
        aiohomekit
        python-otbr-api
      ];

    customComponents = [
      (pkgs.callPackage ./components/pyloxone.nix {
        input = inputs.hass-pyloxone;
      })
      (pkgs.callPackage ./components/eufy_security.nix {
        input = inputs.hass-eufy_security;
      })
    ];

    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      vacuum-card
    ];

    config = lib.mkMerge [
      {
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
      }
      (import ./automations.nix args)
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      21064 # HomeKit integration
      1400 # Sonos integration
    ];
    allowedUDPPorts = [
      5353 # HomeKit integration
    ];
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
