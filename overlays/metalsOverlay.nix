{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  version = "0.11.8";
  outputHash = "sha256-j7je+ZBTIkRfOPpUWbwz4JR06KprMn8sZXONrtI/n8s=";
}
