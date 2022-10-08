{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs = {
    nix.url = "github:nixos/nix/2.9-maintenance";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;

        extraSpecialArgs = {
          inherit inputs;
        };

        inherit system username;
        homeDirectory = "/home/${username}";
        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "22.05";

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
