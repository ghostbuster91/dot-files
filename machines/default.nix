{ self, inputs, lib, ... }:
let
  system = "x86_64-linux";
  # metals is provided by self.overlays.default (built from Maven coords via
  # scala-cli-nix — see modules/flake/metals). smithy-ls is still injected here.
  languageServers = {
    inherit (inputs.nix-smithy-ls.packages.${system}) smithy-lang-smithy-ls;
  };
  overlays = [ inputs.scala-cli-nix.overlays.default self.overlays.default ];
  pkgs-unstable = (import inputs.nixpkgs-unstable {
    inherit system overlays;
    config.allowUnfree = true;
  }) // languageServers;
  pkgs-stable = import inputs.nixpkgs-stable
    {
      inherit system overlays;
      config.allowUnfree = true;
    } // languageServers;
  username = "kghost";
in
{
  flake.nixosConfigurations = {
    focus =
      lib.nixosSystem {
        modules = [ ./focusM2 ];
        specialArgs = { inherit inputs; inherit pkgs-unstable; inherit username; inherit pkgs-stable; inherit self; };
      };
  };

  perSystem = { lib, system, ... }:
    let
      # Only check the configurations for the current system
      sysConfigs = lib.filterAttrs (_name: value: value.pkgs.system == system) self.nixosConfigurations;
    in
    {
      # Add all the nixos configurations to the checks
      checks = lib.mapAttrs' (name: value: { name = "nixos-toplevel-${name}"; value = value.config.system.build.toplevel; }) sysConfigs;
    };
}
