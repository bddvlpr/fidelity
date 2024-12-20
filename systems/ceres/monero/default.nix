{
  services.monero = {
    enable = true;
    mining.enable = false;

    limits = {
      upload = 1024;
      download = 1024;
    };
  };
}
