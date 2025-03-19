{
  pkgs,
  config,
  ...
}:
{
  services.klipper = {
    enable = true;

    user = "moonraker";
    group = "moonraker";

    configFile = pkgs.writeText "klipper.cfg" ''
      [include ${./mainsail.cfg}]
      [include ${./printer.cfg}]

      [virtual_sdcard]
      path: ${config.services.moonraker.stateDir}/gcodes
    '';

    firmwares = {
      mcu = {
        enable = true;
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
        configFile = ./mcu.cfg;
      };
    };
  };
}
