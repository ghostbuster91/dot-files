{ username, pkgs, ... }: {

  environment.systemPackages = with pkgs; [ virt-viewer ];
  virtualisation = {
    docker = {
      package = pkgs.docker_29;
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        bip = "169.254.0.1/16";
      };
    };

    virtualbox.host = {
      enable = false;
      enableExtensionPack = false;
    };
  };
  # note: libvirtd conflicts with virtualbox
  virtualisation.libvirtd.enable = true;

  # block kvm module as it conflicts with virtualbox
  boot.blacklistedKernelModules = [ "kvm" "kvm_intel" "kvm_amd" ];

  users.extraGroups.vboxusers.members = [ username ];
  users.extraGroups.docker.members = [ username ];
}
