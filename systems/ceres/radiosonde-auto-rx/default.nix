{
  virtualisation.oci-containers.containers.radiosonde-auto-rx = {
    image = let
      hash = "3fb4e6c7a2198ca77f612030e6a75c97870014d71dc3013b601102b050261b4f";
    in "ghcr.io/projecthorus/radiosonde_auto_rx@sha256:${hash}";
    ports = ["5000:5000"];
    volumes = [
      "${./station.cfg}:/opt/auto_rx/station.cfg:ro"
      "radiosonde-auto-rx-logs:/opt/auto_rx/log"
    ];
    extraOptions = ["--device=/dev/bus/usb"];
  };
}
