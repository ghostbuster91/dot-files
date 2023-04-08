{
  description = "Home Manager configuration of Kasper Kondzielski";

  inputs =
    {
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
      p_nvim-tmux-resize = {
        url = "github:RyanMillerC/better-vim-tmux-resizer";
        flake = false;
      };
    };

  outputs = inputs @ { home-manager, nixpkgs, nixGL, neovim-nightly-overlay, ... }:
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
