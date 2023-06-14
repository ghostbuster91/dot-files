{ pkgs }:
let
  pname = "tmux-onedark-theme";
  version = "9a830eee4b22b5983b864b35097aa73d2fc771a3";
in
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = pname;
  inherit version;
  rtpFilePath = "tmux-onedark-theme.tmux";
  src = pkgs.fetchFromGitHub {
    owner = "ghostbuster91";
    repo = pname;
    rev = version;
    sha256 = "sha256-XQRGY5oYnn+Np/cc0gE2jhqOSOcKAC20AGZa78dK/F0=";
  };
}
