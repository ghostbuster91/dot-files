{
  nix.buildMachines = [{
    hostName = "beast";
    sshUser = "nix-remote-builder";
    sshKey = "/home/kghost/.ssh/nixremote";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    maxJobs = 8;
    speedFactor = 4;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = false
  '';

  programs.ssh.knownHosts = {
    beastBuilder = {
      hostNames = [ "beast" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwcg1+0/b3eIKQUBwSNMHpo8dNIFCZmEWCEsmS3v6R3";
    };
  };
}
