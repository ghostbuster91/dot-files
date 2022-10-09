{ nixGL, pkgs }:

let
  inherit (nixGL.packages.x86_64-linux) nixGLIntel;
in
pkgs.symlinkJoin {
  name = "alacritty";
  paths = [
    (pkgs.writeShellScriptBin "alacritty" ''
      #!/bin/sh

      ${nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
    '')
    pkgs.alacritty
  ];
}

