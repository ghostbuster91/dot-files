{ pkgs, username, inputs, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./config
    ./greetd
    ./mako
    ./swaylock
    ./waybar
    ./wofi
    ./sway.nix
  ];

  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    eww-wayland # ???
    grim # ???
    hyprpaper # ???
    hyprpicker # ???
    lxqt.lxqt-policykit
    slurp # ???
    wl-clipboard
    # Required if applications are having trouble opening links
    xdg-utils
    wdisplays # display manager
    sfwbar
    killall
    vulkan-validation-layers
    sway

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

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.dconf.enable = true;

  programs.ssh.startAgent = true;

  services.gnome = {
    gnome-keyring.enable = true;
  };
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  security = {
    pam = {
      services = {
        login.enableGnomeKeyring = true;
      };
    };
  };
}
