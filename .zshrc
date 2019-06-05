# :: Zplug - ZSH plugin manager
export ZPLUG_HOME=$HOME/.zplug

# Check if zplug is installed
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "b4b4r07/enhancd", use:init.sh
export ENHANCD_FILTER=fzf

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/common-aliases",   from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "modules/history", from:prezto

alias ls="ls --color"
alias ll="ls -l --color"
alias la="ls -a --color"
zplug "dbkaplun/smart-cd" # automatic ls in dirs, git status in repos

zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq, \
    use:"jq-linux64", \
    if:"[[ $OSTYPE == *linux* ]]"

zplug "plugins/kubectl", from:oh-my-zsh, defer:2
zplug "bonnefoa/kubectl-fzf", defer:3

export NVM_LAZY_LOAD=true
zplug "lukechilds/zsh-nvm"
zplug "cswl/zsh-rbenv"
zplug "nobeans/zsh-sdkman"
zplug "superbrothers/zsh-kubectl-prompt"

zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh

zplug "ahmetb/kubectx", \
	from:gh-r, \
    as:command, \
    use:'(*).sh'

zplug 'junegunn/fzf', \
      as:command, \
      use:'bin/{fzf,fzf-tmux}', \
      if:"[[ $OSTYPE == linux* || $OSTYPE == darwin* ]]", \
      hook-build:'./install --key-bindings --completion --no-update-rc'
zplug "junegunn/fzf", from:github, use:"shell/completion.zsh"
zplug "junegunn/fzf", from:github, use:"shell/key-bindings.zsh"

cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }
gccd() { git clone "$1" && cd "$(basename $_ .git)"; }

# golang: initialize GOPATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

 # Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# https://gist.github.com/anchor/4076792
autoload -U select-word-style
select-word-style bash


zplug load
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

# Manual installation:
# https://github.com/junegunn/fzf
# https://github.com/bonnefoa/kubectl-fzf
#"go get -u github.com/eekwong/kubectl-fzf/cmd/cache_builder"