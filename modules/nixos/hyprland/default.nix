{ pkgs, username, inputs, ... }:
{
  imports = [
    ./config
    ./greetd
    ./mako
    ./swaylock
    ./waybar
    ./wofi
  ];

  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    eww-wayland
    grim
    hyprpaper
    hyprpicker
    lxqt.lxqt-policykit
    slurp
    wl-clipboard
    # Required if applications are having trouble opening links
    xdg-utils
  ];

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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

  programs.dconf.enable = true;

  services.gnome = {
    gnome-keyring.enable = true;
  };

  security = {
    pam = {
      services = {
        login.enableGnomeKeyring = true;
      };
    };
  };
}
