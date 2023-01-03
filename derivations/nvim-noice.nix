{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "noice.nvim";
  version = "256ec7318e227d4a0879f3776bfbe3955f5d2eef";
  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = version;
    sha256 = "sha256-WahLRz8GTHRnV2CRVRWFopzXZuK9P2CFzhcUDPgmEbs=";
  };
}
