{ pkgs, username, ... }:
{
  boot.loader =
    {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  # TODO https://wiki.nixos.org/wiki/WireGuard
  # networking.wg-quick.interfaces.wg0.configFile = "/home/kghost/Downloads/wg0.conf";
  networking = {
    hostId = "d1084363";
    hostName = "focus";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
  };
  hardware = {
    bluetooth.enable = true;
    flipperzero.enable = true;
    graphics.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  fonts.packages = with pkgs; [
    font-awesome
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    # dialout is needed to access serial devices without sudo
    extraGroups = [ "wheel" "networkmanager" "plugdev" "dialout" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    busybox
    vim
    git
    firefox
    google-chrome
    lm_sensors
    wirelesstools
    pciutils
    usbutils
    libva-utils
    sops
    nvtopPackages.full
    pv # stdout generic progress (useful for dd)
    minicom # for UART
    sysstat
    iotop
    # needed for decoding videos from gopro
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  environment.shells = with pkgs; [ zsh ];

  programs = {

    # Enable the 1Password CLI, this also enables a SGUID wrapper so the CLI can authorize against the GUI app
    _1password = {
      enable = true;
    };
    # Enable the 1Passsword GUI with myself as an authorized user for polkit
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };
    zsh.enable = true;
    wireshark.enable = true;
    # Default-on; sets environment.variables.EDITOR = "nano", which beats
    # programs.zsh.sessionVariables in subshells where its sentinel guard skips re-export.
    nano.enable = false;
  };
  services = {
    # power management features
    power-profiles-daemon.enable = false;
    tlp.enable = true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_HWP_ON_AC = "performance";
    };

    # clamav = {
    #   daemon.enable = true;
    #   scanner.enable = true;
    #   updater.enable = true;
    #   fangfrisch.enable = true;
    # };

    # lorri is a nix-shell replacement for project development.
    lorri.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
      allowInterfaces = [ "enp15s0" "wlp0s20f3" ];
    };
    tailscale.enable = true;
  };

  services.udev.packages = with pkgs; [
    via
    platformio-core.udev
  ];
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };
}
