typeset -U path
typeset -U manpath

# prepend to path
if [ "$(uname -s)" = "Darwin" ]; then
	path=(/usr/local/opt/coreutils/libexec/gnubin/ $path)
	manpath=(/usr/local/opt/coreutils/libexec/gnuman $path)
fi

path=(~/.rvm/gems/ruby-1.9.3-p484/bin /usr/local/git/bin $path)
path=($DOTSPATH/zsh/zsh $path)
# prune paths
path=($^path(N))
