{
  inputs,
  lib,
  ...
}: {
  imports =
    [inputs.disko.nixosModules.disko]
    ++ (with inputs.srvos.nixosModules; [
      server
    ]);

  # TODO: Tries growpart on zroot/root
  boot.growPartition = lib.mkForce false;

  disko.devices = {
    disk = {
      alpha = {
        type = "disk";
        device = "/dev/nvme0n1";
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
      beta = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
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
        mode = "mirror";
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