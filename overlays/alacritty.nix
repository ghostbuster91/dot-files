{ nixGL }: self: super:

let
  nixGLIntel = nixGL.packages.x86_64-linux.nixGLIntel;
in
{
  alacritty = (self.symlinkJoin {
    name = "alacritty";
    paths = [
      (self.writeShellScriptBin "alacritty" ''
        #!/bin/sh

        ${nixGLIntel}/bin/nixGLIntel ${super.alacritty}/bin/alacritty "$@"
      '')
      super.alacritty
    ];
  });
}
