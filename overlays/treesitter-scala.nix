{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "2d0e6b8c14236ead27aa86236d2d302fbdf5c24b";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-SL6pIOlwpRA24nSiYzJh1j0MHD3xxshmJKBRp1XrmMU=";
  };
}
  
