{
  virtualisation.oci-containers.containers.radiosonde-auto-rx = {
    image = let
      hash = "067d77cbe66a0ceab23a55859f04d45f3bbe2d14416f4f3cda716f775a9069f4";
    in "ghcr.io/projecthorus/radiosonde_auto_rx@sha256:${hash}";
    ports = ["5000:5000"];
    volumes = [
      "${./station.cfg}:/opt/auto_rx/station.cfg:ro"
      "radiosonde-auto-rx-logs:/opt/auto_rx/log"
    ];
    extraOptions = ["--device=/dev/bus/usb"];
  };
}
