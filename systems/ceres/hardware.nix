{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.srvos.nixosModules.server
    inputs.disko.nixosModules.disko
  ];

  hardware.rtl-sdr.enable = true;

  # TODO: Tries growpart on zroot/root
  boot.growPartition = lib.mkForce false;

  sops.secrets."samba/credentials" = {};

  fileSystems."/mnt/media" = {
    fsType = "cifs";
    device = "//192.168.14.21/NoBackup/Stijn/Media";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      credentials_opts = "credentials=${config.sops.secrets."samba/credentials".path}";
    in [
      automount_opts
      credentials_opts
      "uid=sonarr"
      "gid=media"
      "dir_mode=0775"
      "file_mode=0775"
      "vers=2.0"
    ];
  };

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
