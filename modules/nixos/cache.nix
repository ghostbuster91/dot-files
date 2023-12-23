{ ... }:
{
  nix.settings = {
    substituters = [
      "https://cache.garnix.io"
      "https://cache.nixos.org/"
      "ssh://eu.nixbuild.net"
    ];
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nixbuild.net/kghost0+nixbuild@gmail.com-1:fQWBPOIR5ocwE8INCmMUDErkISWc8mCIibw46hq8j3E="
    ];
  };
}
