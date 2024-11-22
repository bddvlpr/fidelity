{
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    "eufy/username" = {};
    "eufy/password" = {};
  };

  sops.templates."eufy-security-ws.json" = {
    owner = "eufy-security";
    content = let
      inherit (config.sops) placeholder;
    in ''
      {
        "username": "${placeholder."eufy/username"}",
        "password": "${placeholder."eufy/password"}",
        "persistentDir": "/var/lib/eufy-security-ws",
        "country": "BE",
        "language": "en"
      }
    '';
  };

  systemd.services.eufy-security-ws = let
    cfg = config.sops.templates."eufy-security-ws.json".path;
  in {
    enable = true;
    description = "eufy-security-ws";
    wants = ["network-online.target"];
    after = ["network-online.target"];
    reloadTriggers = [cfg];
    serviceConfig = {
      ExecStart = "${pkgs.eufy-security-ws}/bin/eufy-security-server --config ${cfg}";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      WorkingDirectory = "/var/lib/eufy-security-ws";
      User = "eufy-security";
      Group = "eufy-security";
      Restart = "on-failure";
      RestartForceExitStatus = "100";
      SuccessExitStatus = "100";
    };
  };

  users = {
    users.eufy-security = {
      isSystemUser = true;
      group = "eufy-security";
    };
    groups.eufy-security = {};
  };
}
