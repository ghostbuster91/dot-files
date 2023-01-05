{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "ltex-extra.nvim";
  version = "c5046a6eabfee378f781029323efd941fcc53483";
  src = pkgs.fetchFromGitHub {
    owner = "barreiroleo";
    repo = "ltex_extra.nvim";
    rev = version;
    sha256 = "sha256-gTbtjqB6ozoTAkxp0PZUjD/kndxf2eJrXWlkZdj7+OQ";
  };
}
