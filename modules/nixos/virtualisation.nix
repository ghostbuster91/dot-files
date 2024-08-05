{ username, ... }: {

  virtualisation = {
    docker = {
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
      enable = true;
      enableExtensionPack = false;
    };
  };

  users.extraGroups.vboxusers.members = [ username ];
  users.extraGroups.docker.members = [ username ];
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };
}
