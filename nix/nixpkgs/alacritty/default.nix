{ pkgs, ... }:

let
  nixGLIntel = (pkgs.callPackage "${
      builtins.fetchTarball {
        url =
          "https://github.com/guibou/nixGL/archive/c4aa5aa15af5d75e2f614a70063a2d341e8e3461.tar.gz";
        sha256 = "09p7pvdlf4sh35d855lgjk6ciapagrhly9fy8bdiswbylnb3pw5d";
      }
    }/nixGL.nix" { }).nixGLIntel;
in {
  programs.alacritty = {
    enable = true;
    package = (pkgs.symlinkJoin {
      name = "alacritty";
      paths = [
        (pkgs.writeShellScriptBin "alacritty" ''
          #!/bin/sh

          ${nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
        '')
        pkgs.alacritty
      ];
    });
    settings = {
      font = {
        size = 12;

        normal.family = "JetBrains Mono Nerd Font";
        normal.style = "Regular";
        bold.family = "JetBrains Mono Nerd Font";
        bold.style = "Bold";
        italic.family = "JetBrains Mono Nerd Font";
        italic.style = "Italic";
        bold_italic.family = "JetBrains Mono Nerd Font";
        bold_italic.style = "Bold Italic";
      };
    };
  };
}