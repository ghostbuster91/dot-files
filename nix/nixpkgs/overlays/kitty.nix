self: super:

let
  nixGLIntel = (self.callPackage "${
      builtins.fetchTarball {
        url =
          "https://github.com/guibou/nixGL/archive/c4aa5aa15af5d75e2f614a70063a2d341e8e3461.tar.gz";
        sha256 = "09p7pvdlf4sh35d855lgjk6ciapagrhly9fy8bdiswbylnb3pw5d";
      }
    }/nixGL.nix" { }).nixGLIntel;
in {
  kitty = (self.symlinkJoin {
    name = "kitty";
    paths = [
      (self.writeShellScriptBin "kitty" ''
        #!/bin/sh

        ${nixGLIntel}/bin/nixGLIntel ${super.kitty}/bin/kitty "$@"
      '')
      super.kitty
    ];
  });
}
