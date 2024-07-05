{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs =
    {
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs.follows = "nixpkgs-stable";
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hardware.url = "github:nixos/nixos-hardware/master";
      home-manager = {
        url = "github:nix-community/home-manager/release-24.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hyprland = {
        url = "github:hyprwm/hyprland";
      };
      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs";
      };
      sops = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
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
      p_nvim-tree-lua = {
        url = "github:ghostbuster91/nvim-tree.lua/expand_until";
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
      p_nvim-baleia = {
        url = "github:m00qek/baleia.nvim";
        flake = false;
      };
      p_nvim-scratch = {
        url = "github:ghostbuster91/scratch.nvim";
        flake = false;
      };
      p_nvim-hover = {
        url = "github:lewis6991/hover.nvim";
        flake = false;
      };
      p_nvim-gp-nvim = {
        url = "github:Robitx/gp.nvim";
        flake = false;
      };
      p_nvim-tree-lsp = {
        url = "github:antosha417/nvim-lsp-file-operations";
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
      p_treesitter-xml = {
        url = "github:tree-sitter-grammars/tree-sitter-xml";
        flake = false;
      };
      nix-work = {
        url = "/home/kghost/dev/nix-work";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
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
