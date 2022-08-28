{ pkgs, config, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    zplug = {
      enable = true;
      plugins = [
        {
          name = "chisui/zsh-nix-shell";
          tags = [ "at:v0.4.0" ];
        }
        {
          name = "plugins/common-aliases";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "plugins/git";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "plugins/extract";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "plugins/docker";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "plugins/docker-compose";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "MichaelAquilina/zsh-you-should-use";
          tags = [ "at:1.7.3" ];
        }
        {
          name = "rupa/z";
          tags = [ "use:z.sh" "at:v1.11" ];
        }
        {
          name = "changyuheng/fz";
          tags = [ "defer:1" "at:2a4c1bc73664bb938bfcc7c99f473d0065f9dbfd" ];
        }
        {
          name = "b4b4r07/enhancd";
          tags = [ "use:init.sh" "at:v2.2.4" ];
        }
        {
          name = "hlissner/zsh-autopair";
          tags = [ "at:9d003fc02dbaa6db06e6b12e8c271398478e0b5d" ];
        }
        {
          name = "wfxr/forgit";
          tags = [ "at:7b26cd46ac768af51b8dd4b84b6567c4e1c19642" "defer:1" ];
        }
        {
          name = "plugins/tmux";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
      ];
    };
    initExtraFirst = ''
      	ZSH_TMUX_CONFIG=${config.xdg.configHome}/tmux/tmux.conf
    '';
    initExtraBeforeCompInit = ''
      	# fix delete key
      	bindkey "^[[3~" delete-char
      	# turn off beeping
      	unsetopt BEEP

      	autoload -U select-word-style
      	select-word-style bash

      	# ctrl-d drop stash entry
      	FORGIT_STASH_FZF_OPTS='--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"'

      	setopt HIST_IGNORE_ALL_DUPS
      	autoload -U edit-command-line
      	# Emacs style
      	zle -N edit-command-line
      	bindkey '^xe' edit-command-line
      	bindkey '^x^e' edit-command-line
    '';

    localVariables = {
      FZF_DEFAULT_COMMAND = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules --exclude '*.class'";
      FZF_CTRL_T_OPTS = "--ansi --preview '${pkgs.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'";
      FZF_CTRL_T_COMMAND = "${pkgs.fd}/bin/fd -I --type file";
    };
    history = { extended = true; };
    shellAliases = {
      lsd = "${pkgs.exa}/bin/exa --long --header --git --all";
    };
  };
}
