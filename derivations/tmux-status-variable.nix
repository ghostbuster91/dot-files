{ pkgs }:
let
  pname = "tmux-status-variables";
  version = "6f75b024e01c46e35df5ce331e3b2a0f5aeb1b63";
in
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = pname;
  inherit version;
  rtpFilePath = "tmux-status-variables.tmux";
  src = pkgs.fetchFromGitHub {
    owner = "ghostbuster91";
    repo = pname;
    rev = version;
    sha256 = "sha256-JnDyIOC61uw1nc1Nlt5EmsS6iulKHcPtLkfqzmbFEok=";
  };
}
