{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/30d3d79b7d3607d56546dd2a6b49e156ba0ec634";
    home-manager = {
      url = "github:nix-community/home-manager/778af87a981eb2bfa3566dff8c3fb510856329ef";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:guibou/nixGL/c4aa5aa15af5d75e2f614a70063a2d341e8e3461";
      flake = false;
    };
  };

  outputs = { home-manager, nixGL, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;

        extraSpecialArgs = {
          inherit nixGL;
        };

        inherit system username;
        homeDirectory = "/home/${username}";
        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "22.05";

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
