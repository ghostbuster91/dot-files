{ pkgs, username, ... }:
let
  customFonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  };
in
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
    opengl.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  sound.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  fonts.packages = with pkgs; [
    customFonts
    font-awesome
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
    vim
    git
    firefox
    google-chrome
    lm_sensors
    wirelesstools
    pciutils
    usbutils
    glxinfo
    libva-utils
    globalprotect-openconnect
    sops
    nvtop
    pv # stdout generic progress (useful for dd)
    minicom # for UART
    sysstat
    iotop
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

    globalprotect = {
      enable = true;
    };

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
  };

  services.udev.packages = with pkgs; [
    via
  ];
}
