{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs = {
    nix.url = "github:nixos/nix/2.11-maintenance";
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

  outputs = inputs @ { home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (self: super: { alacritty = import ./overlays/alacritty.nix { inherit (inputs) nixGL; pkgs = super; }; })
          (self: super: { derivations = import ./derivations { pkgs = super; inherit (nixpkgs) lib; }; })
        ];
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };

        modules = [
          ./home.nix
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "22.05";
            };
          }
        ];
      };
    };
}
