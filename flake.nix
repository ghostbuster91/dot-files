{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs =
    {
      nix.url = "github:nixos/nix/2.11-maintenance";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };
      hardware.url = "github:ghostbuster91/nixos-hardware/master";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixGL = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      # Neovim plugins
      p_nvim-actions-preview = {
        url = "github:aznhe21/actions-preview.nvim";
        flake = false;
      };
      p_nvim-lsp-inlayhints = {
        url = "github:lvimuser/lsp-inlayhints.nvim";
        flake = false;
      };
      p_nvim-leap = {
        url = "github:ggandor/leap.nvim";
        flake = false;
      };
      p_nvim-metals = {
        url = "github:scalameta/nvim-metals";
        flake = false;
      };
      p_nvim-next = {
        url = "github:ghostbuster91/nvim-next";
        flake = false;
      };
      p_nvim-portal = {
        url = "github:cbochs/portal.nvim";
        flake = false;
      };
      p_nvim-smart-splits-nvim = {
        url = "github:ghostbuster91/smart-splits.nvim";
        flake = false;
      };
    };

  outputs = inputs @ { home-manager, nixpkgs, nixGL, nixpkgs-stable, disko, hardware, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";

      overlays = import ./overlays {
        inherit inputs;
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (self: super: { derivations = import ./derivations { pkgs = super; inherit (nixpkgs) lib; }; })
          overlays
        ];
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      inherit (inputs.nixpkgs.lib) mapAttrs;
    in
    rec {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit username;
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

      nixosConfigurations.kubuntu = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/kubuntu/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.${username} = ./home.nix;
              extraSpecialArgs = { inherit username; inherit pkgs; inherit pkgs-stable; };
            };
          }
          disko.nixosModules.disko
          hardware.nixosModules.focus-m2-gen1
        ];
        specialArgs = { inherit username; };
      };



      checks.${system} =
        let
          hm = mapAttrs (_: c: c.activationPackage) homeConfigurations;
        in
        hm;
    };
}
