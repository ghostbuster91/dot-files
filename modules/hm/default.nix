_:
{
  flake.homeModules = {
    base = ./home.nix;
    nvim = ./neovim;
    git = ./git;
    zsh = ./zsh;
    tmux = ./tmux;
    alacritty = ./alacritty;
    scala = ./scala;
    sway = ./sway;
  };
}
