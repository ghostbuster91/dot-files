source ~/bin/antigen.zsh
antigen use oh-my-zsh

antigen bundle command-not-found
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle vi-mode

antigen theme https://github.com/ghostbuster91/zsh-theme.git ghostbuster91
antigen apply
