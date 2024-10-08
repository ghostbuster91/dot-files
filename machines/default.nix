{ self, inputs, lib, ... }:
let
  system = "x86_64-linux";
  languageServers = {
    inherit (inputs.nix-metals.packages.${system}) metals;
    inherit (inputs.nix-smithy-ls.packages.${system}) disney-smithy-ls;
  };
  pkgs-unstable = (import inputs.nixpkgs-unstable {
    inherit system;
    overlays = [ self.overlays.default ];
    config.allowUnfree = true;
  }) // languageServers;
  pkgs-stable = import inputs.nixpkgs-stable
    {
      inherit system;
      overlays = [ self.overlays.default ];
      config.allowUnfree = true;
    } // languageServers;
  username = "kghost";
in
{
  flake.nixosConfigurations = {
    focus =
      lib.nixosSystem {
        modules = [ ./focusM2 ];
        specialArgs = { inherit inputs; inherit pkgs-unstable; inherit username; inherit pkgs-stable; };
      };
  };

  perSystem = { pkgs, lib, system, ... }:
    let
      # Only check the configurations for the current system
      sysConfigs = lib.filterAttrs (_name: value: value.pkgs.system == system) self.nixosConfigurations;
    in
    {
      # Add all the nixos configurations to the checks
      checks = lib.mapAttrs' (name: value: { name = "nixos-toplevel-${name}"; value = value.config.system.build.toplevel; }) sysConfigs;
    };
}
