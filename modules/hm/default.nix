{ ... }:
{
  # home-manager modules, consumed by the NixOS-embedded home-manager on the
  # `focus` host (see machines/focusM2/default.nix). There is no standalone
  # homeConfigurations output — this host wires home-manager in via NixOS.
  flake.homeModules = {
    base = ./home.nix;
    nvim = ./neovim;
    git = ./git;
    zsh = ./zsh;
    tmux = ./tmux;
    alacritty = ./alacritty;
    scala = ./scala;
    foot = ./foot;
  };
}
