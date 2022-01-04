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
      colors = {
        primary = {
          foreground = "#eeeeec";
          background = "#300a24";
        };
        normal = {
          black = "#2e3436";
          red = "#cc0000";
          green = "#4e9a06";
          yellow = "#c4a000";
          blue = "#3465a4";
          magenta = "#75507b";
          cyan = "#06989a";
          white = "#d3d7cf";
        };
        bright = {
          black = "#555753";
          red = "#ef2929";
          green = "#8ae234";
          yellow = "#fce94f";
          blue = "#729fcf";
          magenta = "#ad7fa8";
          cyan = "#34e2e2";
          white = "#eeeeec";
        };
      };
    };
  };
}
