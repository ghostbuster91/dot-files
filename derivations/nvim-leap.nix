{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-leap";
  version = "a968ab4250840dc879e805f918b4f3b892310a12";
  src = pkgs.fetchFromGitHub {
    owner = "ggandor";
    repo = "leap.nvim";
    rev = version;
    sha256 = "sha256-TcNjuFFRiBLT6oxOPqSl06oUS2NOCnBlldf65b2GOfo=";
  };
}
