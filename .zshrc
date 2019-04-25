# :: Zplug - ZSH plugin manager
export ZPLUG_HOME=$HOME/.zplug

# Check if zplug is installed
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"           
zplug "zsh-users/zsh-autosuggestions"       
zplug "zsh-users/zsh-syntax-highlighting"      

zplug "plugins/common-aliases",   from:oh-my-zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/command-not-found",   from:oh-my-zsh
zplug "plugins/docker-compose",   from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

zplug "modules/history", from:prezto
zplug "modules/directory",  from:prezto

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "plugins/kubectl", from:oh-my-zsh, defer:2
zplug "bonnefoa/kubectl-fzf", defer:3

export NVM_LAZY_LOAD=true
zplug "lukechilds/zsh-nvm"
zplug "cswl/zsh-rbenv"
zplug "nobeans/zsh-sdkman"
zplug "superbrothers/zsh-kubectl-prompt"
zplug "hlissner/zsh-autopair", defer:2

# Enhanced cd
zplug "b4b4r07/enhancd", use:init.sh
export ENHANCD_FILTER=fzf

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }
gccd() { git clone "$1" && cd "$(basename $_ .git)"; }

# golang: initialize GOPATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autoload -U colors; colors
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

#zplug load --verbose
zplug load

# Manual installation:
# https://github.com/junegunn/fzf
# https://github.com/bonnefoa/kubectl-fzf