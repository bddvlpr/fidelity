{
  boot.loader = {
    timeout = 3;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };
}
