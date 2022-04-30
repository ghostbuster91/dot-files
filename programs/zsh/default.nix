{ pkgs, config, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
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
    ];
    zplug = {
      enable = true;
      plugins = [
        {
          name = "chisui/zsh-nix-shell";
          tags = [ "at:v0.4.0" ];
        }
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" "at:v.1.16.1" ];
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
          name = "Aloxaf/fzf-tab";
          tags = [ "at:a677cf770cfce1e3668ba576fecfb7a14f4f39e2" ];
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
    '';

    localVariables = {
      POWERLEVEL9K_MODE = "awesome-patched";
    };
    history = { extended = true; };
    shellAliases = {
      lsd = "exa --long --header --git --all";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";
    };
  };
}
