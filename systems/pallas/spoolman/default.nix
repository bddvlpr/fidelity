{
  virtualisation.oci-containers.containers.spoolman = {
    image = "ghcr.io/donkie/spoolman:0.20.0";
    ports = ["8585:8000"];
    volumes = [
      "spoolman-data:/home/app/.local/share/spoolman"
    ];
  };
}
