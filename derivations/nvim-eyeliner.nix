{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-eyeliner";
  version = "1d28e40cd8f605972102d59fc8aef7995788fb3e";
  src = pkgs.fetchFromGitHub {
    owner = "jinh0";
    repo = "eyeliner.nvim";
    rev = version;
    sha256 = "sha256-XXteTpxxauGNiYKjKS1l+S0v7Jtjx4oM/vFJoxylfxw=";
  };
}
