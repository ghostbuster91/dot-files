{ pkgs, fetchFromGitHub }:
let
  pname = "tmux-status-variables";
  version = "b7d97faa8a5b4db8248cc3d398e623860ba650fe";
in pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = pname;
  version = version;
  rtpFilePath = "tmux-status-variables.tmux";
  src = fetchFromGitHub {
    owner = "odedlaz";
    repo = pname;
    rev = version;
    sha256 = "sha256-UotV2vai4WP2s9rhhZ2DQrlwaM2+O58KDTidEeK3tL0=";
  };
}
