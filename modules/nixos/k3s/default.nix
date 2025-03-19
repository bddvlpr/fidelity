{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sysc.k3s;
in {
  options.sysc.k3s = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    role = mkOption {
      type = types.enum ["server" "agent"];
      default = "server";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."k3s/token".owner = config.services.k3s.user;

    services.k3s = {
      enable = true;
      role = cfg.role;
      tokenFile = config.sops.secrets."k3s/token".path;
    };
  };
}
