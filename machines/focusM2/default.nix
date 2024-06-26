{ inputs, username, pkgs-unstable, pkgs-stable, ... }:
{
  imports =
    [
      inputs.hardware.nixosModules.focus-m2-gen1
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.disko.nixosModules.default
      (import ./disko-config.nix {
        disks = [ "/dev/nvme0n1" "/dev/nvme1n1" ];
      })
      inputs.sops.nixosModules.default
      inputs.self.nixosModules.gnome
      # inputs.self.nixosModules.hyprland
      inputs.self.nixosModules.games
      inputs.self.nixosModules.cache
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.qmk
      inputs.self.nixosModules.virtualisation
      # inputs.self.nixosModules.nixbuild
      ./custom.nix
      inputs.home-manager.nixosModule
      inputs.self.nixosModules.sound
      inputs.self.nixosModules.bluetooth
      inputs.self.nixosModules.android
      inputs.self.nixosModules.ledger
      inputs.self.nixosModules.rpiBuilder
    ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      imports = [
        inputs.self.homeModules.base
        inputs.self.homeModules.alacritty
        inputs.self.homeModules.foot
        inputs.self.homeModules.nvim
        inputs.self.homeModules.zsh
        inputs.self.homeModules.git
        inputs.self.homeModules.tmux
        inputs.self.homeModules.scala
        inputs.nix-work.homeModules.git
      ];
    };
    extraSpecialArgs = { inherit username; inherit pkgs-unstable; inherit pkgs-stable; };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

