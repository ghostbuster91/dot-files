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
  };

  flake.homeConfigurations = {
    focus = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlays.default ];
        config.allowUnfree = true;
      };

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
