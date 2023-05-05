{ disks ? [ "/dev/vdb" "/dev/vdc" ], ... }: {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "256MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "luks";
              start = "256MiB";
              end = "-64GB";
              content = {
                type = "luks";
                name = "nixos";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                content = {
                  type = "zfs";
                  pool = "rpool1";
                };
              };
            }
            {
              name = "swap";
              start = "-64G";
              end = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            }
          ];
        };
      };
      nvme1n1 = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "luks";
              start = "256MiB";
              end = "100%";
              content = {
                type = "luks";
                name = "home";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_write_workqueue"
                  "--perf-no_read_workqueue"
                ];
                content = {
                  type = "zfs";
                  pool = "rpool2";
                };
              };
            }
          ];
        };
      };
    };
    zpool = {
      rpool1 = {
        type = "zpool";

        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          canmount = "off";
          xattr = "sa";
          atime = "off";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          zroot = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs snapshot rpool1/zroot@blank";
            options = {
              mountpoint = "legacy";
            };
          };
          znix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
            };
          };
          zvar = {
            type = "zfs_fs";
            mountpoint = "/var";
            options = {
              mountpoint = "legacy";
            };
          };
        };
      };
      rpool2 = {
        type = "zpool";

        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          canmount = "off";
          xattr = "sa";
          acltype = "posixacl";
          atime = "off";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          zhome = {
            type = "zfs_fs";
            mountpoint = "/home";
            postCreateHook = "zfs snapshot rpool2/zhome@blank";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
            };
          };
        };
      };
    };
  };
}

