{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs =
    {
      nix.url = "github:nixos/nix/2.11-maintenance";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hardware.url = "github:nixos/nixos-hardware/master";
      home-manager = {
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nix-metals = {
        url = "github:ghostbuster91/nix-metals/stable";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nix-smithy-ls = {
        url = "github:ghostbuster91/nix-smithy-ls";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      # Neovim plugins
      p_nvim-actions-preview = {
        url = "github:aznhe21/actions-preview.nvim";
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
        url = "github:mrjones2014/smart-splits.nvim";
        flake = false;
      };
      p_nvim-neogit = {
        url = "github:NeogitOrg/neogit";
        flake = false;
      };
      p_nvim-neotree = {
        url = "github:nvim-neo-tree/neo-tree.nvim/v3.x";
        flake = false;
      };
      p_nvim-telescope-livegrep-args = {
        url = "github:nvim-telescope/telescope-live-grep-args.nvim";
        flake = false;
      };
      p_nvim-substitute = {
        url = "github:gbprod/substitute.nvim";
        flake = false;
      };
      p_nvim-local-highlight = {
        url = "github:tzachar/local-highlight.nvim";
        flake = false;
      };
      p_treesitter-scala = {
        url = "github:tree-sitter/tree-sitter-scala";
        flake = false;
      };
      p_treesitter-devicetree = {
        url = "github:joelspadin/tree-sitter-devicetree";
        flake = false;
      };
      p_treesitter-hocon = {
        url = "github:antosha417/tree-sitter-hocon";
        flake = false;
      };
    };

  outputs = inputs @ { home-manager, nixpkgs-unstable, nixpkgs, disko, hardware, sops-nix, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";

      overlays = import ./overlays {
        inherit inputs;
        inherit system;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          overlays
        ];
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit (inputs.nixpkgs.lib) mapAttrs;
    in
    rec {
      nixosConfigurations.focus = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/focus/configuration.nix
          ./modules/games.nix
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
            nix.registry = {
              nixpkgs.flake = inputs.nixpkgs;
              nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
            };
            nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
          }
          sops-nix.nixosModules.sops
        ];
        specialArgs = { inherit username; inherit pkgs-unstable; };
      };

      checks.${system} =
        let
          os = mapAttrs (_: c: c.config.system.build.toplevel) nixosConfigurations;
        in
        os;

      formatter.${system} = pkgs-unstable.nixpkgs-fmt;
    };
}
