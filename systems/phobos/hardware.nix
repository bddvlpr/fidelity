{inputs, ...}: {
  imports =
    [inputs.disko.nixosModules.disko]
    ++ (with inputs.srvos.nixosModules; [
      server
      hardware-hetzner-cloud-arm
    ]);

  disko.devices = {
    disk = {
      alpha = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              name = "ESP";
              size = "256M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          atime = "off";
          compression = "lz4";
        };

        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };

          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
        };
      };
    };
  };
}
