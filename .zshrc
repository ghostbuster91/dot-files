source ~/bin/antigen.zsh
antigen use oh-my-zsh

antigen bundle command-not-found
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen bundle docker-compose
export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm
antigen bundle cswl/zsh-rbenv
antigen apply

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }
gccd() { git clone "$1" && cd "$(basename $_ .git)"; }
alias copy='xclip -i -selection clipboard'