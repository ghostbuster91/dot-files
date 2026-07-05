{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs =
    {
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs.follows = "nixpkgs-stable";
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hardware.url = "github:nixos/nixos-hardware/master";
      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hyprland = {
        url = "github:hyprwm/hyprland";
      };
      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs";
      };
      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      scala-cli-nix = {
        url = "github:scala-nix/scala-cli-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      # Neovim plugins
      p_nvim-next = {
        url = "github:ghostbuster91/nvim-next";
        flake = false;
      };
      p_nvim-portal = {
        url = "github:cbochs/portal.nvim";
        flake = false;
      };
      p_nvim-telescope-livegrep-args = {
        url = "github:nvim-telescope/telescope-live-grep-args.nvim";
        flake = false;
      };
      p_nvim-scratch = {
        url = "github:ghostbuster91/scratch.nvim";
        flake = false;
      };
      p_nvim-tree-lsp = {
        url = "github:antosha417/nvim-lsp-file-operations";
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
      p_treesitter-xml = {
        url = "github:tree-sitter-grammars/tree-sitter-xml";
        flake = false;
      };
      nixos-server = {
        url = "github:ghostbuster91/nixos-server";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      agenix = {
        url = "github:ryantm/agenix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./modules
        ./machines
        inputs.treefmt-nix.flakeModule
      ];
      perSystem.treefmt = {
        imports = [ ./treefmt.nix ];
        config = {
          settings.formatter.stylua = {
            options = [
              "--indent-type"
              "Spaces"
            ];
          };
        };
      };
    };
}
