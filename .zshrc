source ~/bin/antigen.zsh
antigen use oh-my-zsh

antigen bundle command-not-found
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle vi-mode
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen bundle docker-compose
antigen apply

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }