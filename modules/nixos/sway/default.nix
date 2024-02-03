{ pkgs, username, ... }: {
  # To set up Sway using Home Manager, first you must enable Polkit in your nix configuration:


  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_RENDERER = "vulkan";
  environment.sessionVariables.WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0
";

  # configuring kanshi
  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    environment = { XDG_CONFIG_HOME = "/home/kghost/.config"; };
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

  environment = {
    systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      glmark2
      vulkan-validation-layers
      sway
      wdisplays # display manager
    ];
  };


  home-manager.users.${username} = _: {
    home.file = {
      ".config/sway/config".text = ''
        # output HDMI-A-1 resolution 1920x1080 position 1920,0
        # output eDP-1 resolution 1920x1080 position 0,0

        #exec sleep 5; systemctl --user start kanshi.service

        set $term foot
        set $mod Mod4

        bindsym $mod+Return exec $term
      '';
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
    nvidiaSettings = true;

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
}


