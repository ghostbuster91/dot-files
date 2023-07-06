{ pkgs, src }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "custom";
  inherit src;
}
  
