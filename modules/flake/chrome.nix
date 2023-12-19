{ pkgs }:
pkgs.symlinkJoin {
  name = "google-chrome";
  paths = [
    (pkgs.writeShellScriptBin "google-chrome" ''
      #!/bin/sh
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      ${pkgs.google-chrome}/bin/google-chrome-stable "$@"
    '')
    pkgs.google-chrome
  ];
}

