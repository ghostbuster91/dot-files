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
      # metals is provided by self.overlays.default (built from Maven coords via
      # scala-cli-nix — see modules/flake/metals). smithy-ls is still injected here.
      languageServers = {
        inherit (inputs.nix-smithy-ls.packages.${system}) smithy-lang-smithy-ls;
      };
      overlays = [ inputs.scala-cli-nix.overlays.default self.overlays.default ];
      pkgs-unstable = (import inputs.nixpkgs-unstable {
        inherit system overlays;
        config.allowUnfree = true;
      }) // languageServers;

      pkgs-stable = (import inputs.nixpkgs {
        inherit system overlays;
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
