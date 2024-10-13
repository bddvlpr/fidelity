{
  virtualisation.oci-containers.containers.radiosonde-auto-rx = {
    image = let
      hash = "c09bd02c609978c98946d94149e9a3b6e54f7a8cbd5e8ccc682ef6f10991d95f";
    in "ghcr.io/projecthorus/radiosonde_auto_rx@sha256:${hash}";
    ports = ["5000:5000"];
    volumes = [
      "${./station.cfg}:/opt/auto_rx/station.cfg:ro"
      "radiosonde-auto-rx-logs:/opt/auto_rx/log"
    ];
    extraOptions = ["--device=/dev/bus/usb"];
  };
}
