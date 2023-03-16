{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  version = "0.11.11";
  outputHash = "sha256-oz4lrRnpVzc9kN+iJv+mtV/S1wdMKwJBkKpvmWCSwE0=";
}
