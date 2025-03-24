{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.default ];

  environment.persistence."/persist".directories = [
    "/etc/ssh"
    "/var/log"
    "/var/lib/nixos"
    "/var/lib/systemd/coredump"
  ];

  boot.initrd.systemd.services.zfs-rollback-rpool = {
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.zfs}/bin/zfs rollback -r rpool/local/root@blank";
    };
  };
}
