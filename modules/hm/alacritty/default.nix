{ pkgs-unstable, ... }: {

  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    settings = {
      env = {
        ZSH_TMUX_AUTOSTART = "true";
      };
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
          foreground = "#dcd7ba";
          background = "#1f1f28";
        };
        normal = {
          black = "#090618";
          red = "#c34043";
          green = "#76946a";
          yellow = "#c0a36e";
          blue = "#7e9cd8";
          magenta = "#957fb8";
          cyan = "#6a9589";
          white = "#c8c093";
        };
        bright = {
          black = "#727169";
          red = "#e82424";
          green = "#98bb6c";
          yellow = "#e6c384";
          blue = "#7fb4ca";
          magenta = "#938aa9";
          cyan = "#7aa89f";
          white = "#dcd7ba";
        };
        selection = {
          background = "#2d4f67";
          foreground = "#c8c093";
        };
        indexed_colors = [
          { index = 16; color = "#ffa066"; }
          { index = 17; color = "#ff5d62"; }
        ];
      };
      key_bindings = [{
        key = "Return";
        mods = "Shift";
        chars = "\\x1b[13;2u";
      }
        {
          key = "Return";
          mods = "Control";
          chars = "\\x1b[13;5u";
        }];
    };
  };
}
