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
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ { home-manager, nixpkgs, nixGL, neovim-nightly-overlay, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";

      overlays = import ./overlays {
        inherit nixGL;
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (self: super: { derivations = import ./derivations { pkgs = super; inherit (nixpkgs) lib; }; })
          overlays
          neovim-nightly-overlay.overlay
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
