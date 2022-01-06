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
  nixpkgs.overlays = [
    (self: super: {
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
    })
  ];

  programs.kitty = {
    enable = true;
    settings = {
      scrollback_pager =
        "~/pager.sh 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";
      font_family = "JetBrains Mono Regular";
      italic_font = "JetBrains Mono Italic";
      bold_font = "JetBrains Mono ExtraBold";
      bold_italic_font = "JetBrains Mono ExtraBold Italic";

      font_size = 12;

      shell = "${pkgs.zsh}/bin/zsh";
      shell_integration = "enabled";

      # ubuntu theme
      background = "#300a24";
      foreground = "#eeeeec";
      cursor = "#bbbbbb";
      selection_background = "#b4d5ff";
      color0 = "#2e3436";
      color8 = "#555753";
      color1 = "#cc0000";
      color9 = "#ef2929";
      color2 = "#4e9a06";
      color10 = "#8ae234";
      color3 = "#c4a000";
      color11 = "#fce94f";
      color4 = "#3465a4";
      color12 = "#729fcf";
      color5 = "#75507b";
      color13 = "#ad7fa8";
      color6 = "#06989a";
      color14 = "#34e2e2";
      color7 = "#d3d7cf";
      color15 = "#eeeeec";
      selection_foreground = "#300a24";
    };
  };
}
