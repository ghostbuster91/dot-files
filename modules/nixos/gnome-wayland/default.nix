{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
    };
    displayManager.defaultSession = "gnome";

    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    # Configure keymap in X11
    xserver.xkb.layout = "pl";
    gnome = {
      gnome-keyring.enable = true;
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gedit # text editor
    gnome-tour
  ]) ++ (with pkgs; [
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  hardware.pulseaudio.enable = false;
  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaPersistenced = true;
    # Reverse sync is not compatible with the open source kernel module
    open = false;

    prime = {
      reverseSync.enable = true;

      #enable if using an external GPU
      allowExternalGpu = false;
    };
  };
  security = {
    pam = {
      services = {
        login.enableGnomeKeyring = true;
      };
    };
  };
  programs.ssh.startAgent = true;
}
