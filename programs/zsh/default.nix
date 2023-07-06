{ pkgs, config, lib, pkgs-unstable, ... }:
let
  omz = "${pkgs-unstable.oh-my-zsh}/share/oh-my-zsh/";
  z-rupa = pkgs.fetchFromGitHub {
    owner = "ghostbuster91";
    repo = "z";
    rev = "b82ac78a2d4457d2ca09973332638f123f065fd1";
    hash = "sha256-4jMHh1GVRdFNjUjiPH94vewbfLcah7Agu153zjVNE14=";
  };
  z-fz = pkgs.fetchFromGitHub {
    owner = "ghostbuster91";
    repo = "fz.sh";
    rev = "7b4e215f5887b24e1ef725ffdb89f3479e913875";
    hash = "sha256-H+E4Eh7ms8NRQ+JHkj3ynne/pg7MWXOTYVp5baI58aM=";
  };
  zsh-autopair = pkgs.fetchFromGitHub {
    owner = "hlissner";
    repo = "zsh-autopair";
    rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
    hash = "sha256-PXHxPxFeoYXYMOC29YQKDdMnqTO0toyA7eJTSCV6PGE=";
  };

in
{
  programs.starship = import ./starship.nix { inherit lib; };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs-unstable.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs-unstable.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = pkgs-unstable.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "omz-common-aliases";
        src = omz;
        file = "plugins/common-aliases/common-aliases.plugin.zsh";
      }
      {
        name = "omz-git";
        src = omz;
        file = "plugins/git/git.plugin.zsh";
      }
      {
        name = "omz-extract";
        src = omz;
        file = "plugins/extract/extract.plugin.zsh";
      }
      {
        name = "omz-docker";
        src = omz;
        file = "plugins/docker/docker.plugin.zsh";
      }
      {
        name = "omz-docker-compose";
        src = omz;
        file = "plugins/docker-compose/docker-compose.plugin.zsh";
      }
      {
        name = "zsh-forgit";
        src = pkgs.zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        name = "omz-tmux";
        src = omz;
        file = "plugins/tmux/tmux.plugin.zsh";
      }
      {
        name = "z-rupa";
        src = z-rupa;
        file = "z.sh";
      }
      {
        name = "z-fz";
        src = z-fz;
        file = "fz.plugin.zsh";
      }
      {
        name = "zsh-autopair";
        src = zsh-autopair;
        file = "zsh-autopair.plugin.zsh";
      }
    ];
    initExtraFirst = ''
      zmodload zsh/zprof
      ZSH_TMUX_CONFIG=${config.xdg.configHome}/tmux/tmux.conf
    '';
    initExtraBeforeCompInit = ''
      # fix delete key
      bindkey "^[[3~" delete-char

      # turn off beeping
      unsetopt BEEP

      # ctrl-d drop stash entry
      FORGIT_STASH_FZF_OPTS='--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"'
      setopt HIST_IGNORE_ALL_DUPS
      autoload -U edit-command-line

      # Emacs style
      zle -N edit-command-line
      bindkey '^xe' edit-command-line
      bindkey '^x^e' edit-command-line

      autoload -U select-word-style
      select-word-style bash
    '';

    localVariables = {
      FZF_DEFAULT_COMMAND = "${pkgs-unstable.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules --exclude '*.class'";
      FZF_CTRL_T_OPTS = "--ansi --preview '${pkgs-unstable.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'";
      FZF_CTRL_T_COMMAND = "${pkgs-unstable.fd}/bin/fd -I --type file";
    };
    history = { extended = true; };
    shellAliases = {
      lsd = "${pkgs-unstable.exa}/bin/exa --long --header --git --all";
    };
    initExtra = ''
      if test -f "$HOME/.secrets.sh"; then
        source ~/.secrets.sh
      fi
    '';
  };
}
