{ lib, config, ... }: with lib;
let
  cfg = config.sway-hm;
in
{

  options.sway-hm.enable = mkEnableOption "sway-hm";

  config = mkIf cfg.enable
    {
      wayland.windowManager.sway = {
        enable = true;
        config = rec {
          modifier = "Mod4";
          # Use kitty as default terminal
          terminal = "alacritty";
          startup = [
            # Launch Firefox on start
            { command = "firefox"; }
          ];
        };
      };
    };
}
