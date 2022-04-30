{ pkgs, lib, rustPlatform, fetchFromGitHub }:
let
  pname = "tmux-thumbs";
  version = "0.7.1";
  sha256 = "sha256-PH1nscmVhxJFupS7dlbOb+qEwG/Pa/2P6XFIbR/cfaQ=";
  tmux-thumbs-binary = rustPlatform.buildRustPackage {
    pname = pname;
    version = version;

    src = fetchFromGitHub {
      owner = "fcsonline";
      repo = pname;
      rev = version;
      sha256 = sha256;
    };

    cargoSha256 = "sha256-HzuNwN1KI8shDeF56qJZk6hmU2XS11x6d7YY3Q2W9c9=";

    patches = [ ./fix.patch ];
    postPatch = ''
      substituteInPlace src/swapper.rs --replace '@@replace-me@@' $out/bin
    '';
    meta = { };
  };
in
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = pname;
  version = version;
  rtpFilePath = "tmux-thumbs.tmux";
  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = sha256;
  };
  patches = [ ./fix.patch ];
  postInstall = ''
    substituteInPlace $target/tmux-thumbs.sh --replace '@@replace-me@@' '${tmux-thumbs-binary}/bin/tmux-thumbs'
  '';
}
