{ pkgs }:
pkgs.fetchFromGitHub {
  owner = "tree-sitter";
  repo = "tree-sitter-scala";
  rev = "40cb5fc38c5b58441faa2afb78d3ede730c9c206";
  sha256 = "sha256-kwoDs7zPwZH93bmlEjhlPf0l9le4whEDmQtcIyPK1XQ=";
}

