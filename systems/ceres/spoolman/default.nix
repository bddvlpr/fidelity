{
  virtualisation.oci-containers.containers.spoolman = {
    image = "ghcr.io/donkie/spoolman:0.21.0";
    ports = [ "8000:8000" ];
    volumes = [
      "spoolman-data:/home/app/.local/share/spoolman"
    ];
  };
}
