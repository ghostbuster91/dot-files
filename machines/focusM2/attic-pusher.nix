{ config, inputs, pkgs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.nixos-server.nixosModules.attic-watch-store
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets.attic-pusher-config.file =
    "${inputs.nixos-server}/secrets/attic-pusher-config.age";

  services.attic-watch-store = {
    enable = true;
    cache = "malina5:system";
    credentialsFile = config.age.secrets.attic-pusher-config.path;
  };

  environment.systemPackages = [ pkgs.attic-client ];
}
