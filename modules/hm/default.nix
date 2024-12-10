{ self, inputs, ... }:
{
  flake.homeModules = {
    base = ./home.nix;
    nvim = ./neovim;
    git = ./git;
    zsh = ./zsh;
    tmux = ./tmux;
    alacritty = ./alacritty;
    scala = ./scala;
    foot = ./foot;
  };

  flake.homeConfigurations =
    let
      username = "kghost";
      system = "x86_64-linux";
      languageServers = {
        inherit (inputs.nix-metals.packages.${system}) metals;
        inherit (inputs.nix-smithy-ls.packages.${system}) disney-smithy-ls;
      };
      pkgs-unstable = (import inputs.nixpkgs-unstable {
        inherit system;
        overlays = [ self.overlays.default ];
        config.allowUnfree = true;
      }) // languageServers;

      pkgs-stable = (import inputs.nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
        config.allowUnfree = true;
      }) // languageServers;
    in
    {
      focus = inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username; inherit pkgs-unstable; inherit pkgs-stable; };
        pkgs = pkgs-stable;
        modules = [
          self.homeModules.base
          self.homeModules.nvim
          self.homeModules.git
          self.homeModules.zsh
          self.homeModules.tmux
          self.homeModules.alacritty
          self.homeModules.scala
        ];
      };
    };
}
