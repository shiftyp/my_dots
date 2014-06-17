# completions
unsetopt menu_complete

setopt auto_menu
setopt complete_in_word
setopt always_to_end

setopt correct nocorrectall

#directories
setopt auto_name_dirs

zmodload -i zsh/complist

eval $(dircolors $DOTSPATH/zsh/dircolors-solarized/dircolors.256dark)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# case-insensitive substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:*:*:*:*' menu select=1 _complete _ignored _approximate

# use a cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path $DOTSPATH/zsh/zsh/cache

# ignore _functions
zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle '*' single-ignored complete
