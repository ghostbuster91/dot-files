{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager/778af87a981eb2bfa3566dff8c3fb510856329ef";
    nixpkgs.url = "github:nixos/nixpkgs/30d3d79b7d3607d56546dd2a6b49e156ba0ec634";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "kghost";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;

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
