{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-eyeliner";
  version = "353e7b2f517953c48608ee158ebd161ca5b6cfae";
  src = pkgs.fetchFromGitHub {
    owner = "jinh0";
    repo = "eyeliner.nvim";
    rev = version;
    sha256 = "sha256-XBikd1Io25NkeN00bWBf63zbGQSWpLObH/bWBvlYFZE=";
  };
}
