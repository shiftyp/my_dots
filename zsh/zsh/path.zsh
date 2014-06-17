typeset -U path
typeset -U manpath

# prepend to path
if [ "$(uname -s)" = "Darwin" ]; then
	path=(/usr/local/opt/coreutils/libexec/gnubin/ $path)
	manpath=(/usr/local/opt/coreutils/libexec/gnuman $path)
fi

path=(~/.rvm/bin $path)
path=(~/.nvm/bin $path)

# prune paths
path=($^path(N))
