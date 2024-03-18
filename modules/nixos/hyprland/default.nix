{ pkgs, username, inputs, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./config
    ./greetd
    ./mako
    ./swaylock
    ./waybar
  ];

  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # always use nvidia offload
  environment.sessionVariables.__VK_LAYER_NV_optimus = "NVIDIA_only";
  environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  environment.sessionVariables.__NV_PRIME_RENDER_OFFLOAD = "1";
  environment.sessionVariables.__NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";

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
    fuzzel
  ];

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  users.users.${username}.extraGroups = [ "video" ];
  programs.light.enable = true;

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
      reverseSync.enable = true;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = false;

      #enable if using an external GPU
      allowExternalGpu = true; # ?
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
