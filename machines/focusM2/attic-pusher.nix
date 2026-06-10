{ config, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.nixos-server.nixosModules.attic-watch-store
  ];

  age.identityPaths = [ "/home/kghost/.ssh/id_ed25519" ];

  age.secrets.attic-pusher-config.file =
    "${inputs.nixos-server}/secrets/attic-pusher-config.age";

  services.attic-watch-store = {
    enable = true;
    cache = "malina5:system";
    credentialsFile = config.age.secrets.attic-pusher-config.path;
  };
}
