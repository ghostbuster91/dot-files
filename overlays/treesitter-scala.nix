{ pkgs, ts-build }:

pkgs.fetchFromGitHub {
  owner = "tree-sitter";
  repo = "tree-sitter-scala";
  rev = "94bb82c3aa68b08cf23f7458e75adcd558c40bef";
  sha256 = "sha256-xK9l1eIiTef1NwAKuzSOzQF5sSsEqPk+gxkULxCakhY=";
}

