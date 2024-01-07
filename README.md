# dot-files

![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=Garnix&color=blue&style=flat&logo=nixos&link=https://garnix.io&labelColor=111212)

Installation instructions:

```sh
$ nix shell nixpkgs#git --experimental-features "nix-command flakes"
```

```
--arg disks '[ "/dev/nvme0n1" "/dev/nvme1n1" ]'
```

unmount all mount points

```sh
$ zpool export -fa
```
