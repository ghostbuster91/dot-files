{ pkgs, ... }: {

  programs.alacritty = {
    enable = true;
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
          foreground = "#d3d7cf";
          background = "#2e3436";
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
