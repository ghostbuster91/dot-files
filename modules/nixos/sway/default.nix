{ pkgs, lib, username, config, ... }: with lib;
let
  cfg = config.sway;
in
{

  options.sway.enable = mkEnableOption "sway";
  config = mkIf cfg.enable {

    # To set up Sway using Home Manager, first you must enable Polkit in your nix configuration:
    security.polkit.enable = true;

    users.users.${username}.extraGroups = [ "video" ];
    programs.light.enable = true;

    # Allow swaylock to unlock the computer for us
    security.pam.services.swaylock = {
      text = "auth include login";
    };

    # configuring kanshi
    systemd.user.services.kanshi = {
      description = "Kanshi output autoconfig ";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      environment = { XDG_CONFIG_HOME = "/home/${username}/.config"; };
      serviceConfig = {
        # kanshi doesn't have an option to specifiy config file yet, so it looks
        # at .config/kanshi/config
        ExecStart = ''
          ${pkgs.kanshi}/bin/kanshi
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };

    hardware.nvidia = {
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      nvidiaPersistenced = false;
      # Reverse sync is not compatible with the open source kernel module
      open = false;

      prime = {
        reverseSync.enable = false;
        offload = {
          enable = false;
          enableOffloadCmd = false;
        };
        sync.enable = true;

        #enable if using an external GPU
        allowExternalGpu = false;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        glxinfo
        vulkan-tools
        glmark2
      ];
    };


    # Configure keymap in X11
    services.xserver.layout = "pl";
    services.xserver = {
      videoDrivers = [ "nvidia" ];
      displayManager.gdm.wayland = true;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = lib.getExe pkgs.sway;
          user = "kghost";
        };
        default_session = initial_session;
      };
    };

  };
}
