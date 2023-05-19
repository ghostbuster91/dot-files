{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs =
    {
      nix.url = "github:nixos/nix/2.11-maintenance";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hardware.url = "github:ghostbuster91/nixos-hardware/master";
      home-manager = {
        url = "github:nix-community/home-manager/release-22.11";
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

      # misc 
      openconnect-sso = {
        url = "github:vlaci/openconnect-sso";
        flake = false;
      };
    };

  outputs = inputs @ { home-manager, nixpkgs-unstable, nixGL, nixpkgs, disko, hardware, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";

      openconnectOverlay = import "${inputs.openconnect-sso}/overlay.nix";
      overlays = import ./overlays {
        inherit inputs;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (self: super: { derivations = import ./derivations { pkgs = super; inherit (pkgs) lib; }; })
          overlays
          openconnectOverlay
        ];
      };
      pkgs = import nixpkgs {
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
          inherit pkgs-unstable;
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

      nixosConfigurations.focus = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/focus/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.${username} = ./home.nix;
              extraSpecialArgs = { inherit username; inherit pkgs-unstable; };
            };
          }
          disko.nixosModules.disko
          hardware.nixosModules.focus-m2-gen1
          # flake registry
          {
            nix.registry.nixpkgs.flake = inputs.nixpkgs;
          }
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
