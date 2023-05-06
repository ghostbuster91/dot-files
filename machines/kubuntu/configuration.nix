# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, lib, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ./disko-config.nix {
        disks = [ "/dev/nvme0n1" "/dev/nvme1n1" ]; # replace this with your disk name i.e. /dev/nvme0n1
      })
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.enableCryptodisk = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;

  networking.hostId = "d1084363";
  networking.hostName = "kubuntu"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  hardware.bluetooth.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    desktopManager = {
      xfce.enable = true;
    };
    videoDrivers = [ "nvidia" ];
  };
  hardware.opengl.enable = true;

  hardware.nvidia = {
    powerManagement = {
      enable = true;
    };
    prime = {
      offload.enable = false;
      sync.enable = true;
      sync.allowExternalGpu = true;
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kghost = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    firefox
    lm_sensors
    wirelesstools
    pciutils
    usbutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.autorandr =
    let
      builtin = {
        config = {
          crtc = 4;
          mode = "1920x1080";
          rate = "60.02";
        };
        fingerprint = "00ffffffffffff0038704b0000000000011d0104a5221378039d45a3564d9e270e4e5100000001010101010101010101010101010101008280a070381f403020350058c21000001a008280a0703832463020350058c21000001a000000fd00283c43430e010a202020202020000000fe004c4d3135364c462d314630320a005f";
      };
      external = {
        config = {
          crtc = 1;
          mode = "2560x1440";
          rate = "143.91";
        };
        fingerprint = "00ffffffffffff0010acdb414c4e4344131f0103803c2278ea8cb5af4f43ab260e5054a54b00d100d1c0b300a94081808100714fe1c0565e00a0a0a029503020350055502100001a000000ff004753374b5438330a2020202020000000fc0044454c4c205332373231444746000000fd0030901ee63c000a20202020202001d602034bf1525a3f101f2005140413121103020106071516230907078301000067030c002000383c67d85dc4017880016d1a0000020b3090e60f62256230e305c000e200d5e606050162623e40e7006aa0a067500820980455502100001a6fc200a0a0a055503020350055502100001a00000000000000000000000000000000d6";
      };
    in
    {
      enable = true;
      profiles = {
        standalone = {
          config = {
            "eDP-1-1" = builtin.config // {
              enable = true;
              primary = true;
              position = "0x0";
            };
          };
          fingerprint = {
            "eDP-1-1" = builtin.fingerprint;
          };
        };
        home = {
          config = {
            "HDMI-0" = external.config // {
              enable = true;
              primary = true;
              position = "1920x0";
            };
            "eDP-1-1" = builtin.config // {
              enable = true;
              primary = false;
              position = "0x0";
            };
          };
          fingerprint = {
            "HDMI-0" = external.fingerprint;
            "eDP-1-1" = builtin.fingerprint;
          };
        };
        home-external = {
          config = {
            "HDMI-0" = external.config // {
              enable = true;
              primary = true;
              position = "0x0";
            };
            "eDP-1-1" = builtin.config // {
              enable = false;
              primary = false;
              position = "2560x0";
            };
          };
          fingerprint = {
            "HDMI-0" = external.fingerprint;
            "eDP-1-1" = builtin.fingerprint;
          };
        };
      };
    };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
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
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

