{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.default ];

  boot.initrd.systemd.services.zfs-import-rpool.serviceConfig = {
    ExecStartPre = "${config.boot.zfs.package}/bin/zpool import -N -f rpool";
    Restart = "on-failure";
  };

  fileSystems."/persist".neededForBoot = true;

  disko.devices = {
    zpool.rpool = {
      type = "zpool";
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        compression = "zstd";
        mountpoint = "none";
        xattr = "sa";
      };

      options.ashift = "12";

      datasets = {
        "local" = {
          type = "zfs_fs";
          options.mountpoint = "none";
        };

        "local/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options."com.sun:auto-snapshot" = "false";
        };

        "local/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options."com.sun:auto-snapshot" = "true";
        };

        "local/root" = {
          type = "zfs_fs";
          mountpoint = "/";
          options."com.sun:auto-snapshot" = "false";
          postCreateHook = "zfs snapshot rpool/local/root@blank";
        };
      };
    };
  };
}
