{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-ssr";
  version = "97a9e1e319eec2d7e9731be4c6ac9638a1a2d79d";
  src = pkgs.fetchFromGitHub {
    owner = "cshuaimin";
    repo = "ssr.nvim";
    rev = version;
    hash = "sha256-fQEaV5RK9ZGIi+KsAiH9xSk7Adaby1GPcIU/2uS5+bs=";
  };
}
