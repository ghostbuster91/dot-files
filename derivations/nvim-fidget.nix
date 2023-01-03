{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "fidget.nvim";
  version = "44585a0c0085765195e6961c15529ba6c5a2a13b";
  src = pkgs.fetchFromGitHub {
    owner = "j-hui";
    repo = "fidget.nvim";
    rev = version;
    sha256 = "sha256-FC0vjzpFhXmE/dtQ8XNjLarndf9v3JbokBxnK3yVVYQ";
  };
}
