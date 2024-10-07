{
  virtualisation.oci-containers.containers.radiosonde-auto-rx = {
    image = "ghcr.io/projecthorus/radiosonde_auto_rx:testing";
    ports = ["5000:5000"];
    volumes = [
      "${./station.cfg}:/opt/auto_rx/station.cfg:ro"
      "radiosonde-logs:/opt/auto_rx/log"
    ];
    extraOptions = ["--device=/dev/bus/usb"];
  };
}
