# Pure modified
# by Sindre Sorhus, modified by Ryan Lynch
# https://github.com/sindresorhus/pure
# MIT License

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

export VIRTUAL_ENV_DISABLE_PROMPT=1

# Outputs symbol or hostname
p_host() {
	local host
	if [[ -n $REGULAR_HOSTNAMES ]]; then
		for (( i = 1; i < ${#REGULAR_HOSTNAMES[@]} + 1; i++ )); do
			if [ "${REGULAR_HOSTNAMES[$i]}" = "`hostname`" ]; then
				host="%F{red}${REGULAR_HOST_SYMBOLS[$i]}%f ";
			fi
		done
	fi
	[[ -z $host ]] && host="%F{yellow}`hostname`%f"
	echo $host
}

# colored path
function p_colored_path {
  local slash="%F{cyan}/%f"
  echo "${${PWD/#$HOME/~}//\//$slash}"
}

# vcs info
function p_vcs {
  vcs_info
  echo $vcs_info_msg_0_
}

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
prompt_pure_human_time() {
	local tmp=$1
	local days=$(( tmp / 60 / 60 / 24 ))
	local hours=$(( tmp / 60 / 60 % 24 ))
	local minutes=$(( tmp / 60 % 60 ))
	local seconds=$(( tmp % 60 ))
	(( $days > 0 )) && echo -n "${days}d "
	(( $hours > 0 )) && echo -n "${hours}h "
	(( $minutes > 0 )) && echo -n "${minutes}m "
	echo "(${seconds}s) "
}

# fastest possible way to check if repo is dirty
prompt_pure_git_dirty() {
	# check if we're in a git repo
	command git rev-parse --is-inside-work-tree &>/dev/null || return
	# check if it's dirty
	[[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && local umode="-uno" || local umode="-unormal"
	command test -n "$(git status --porcelain --ignore-submodules ${umode})"

	(($? == 0)) && echo '*'
}

# displays the exec time of the last command if set threshold was exceeded
prompt_pure_cmd_exec_time() {
	local stop=$EPOCHSECONDS
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
	(($elapsed > ${PURE_CMD_MAX_EXEC_TIME:=5})) && prompt_pure_human_time $elapsed
}

prompt_pure_preexec() {
	cmd_timestamp=$EPOCHSECONDS

	# shows the current dir and executed command in the title when a process is active
	print -Pn "\e]0;"
	echo -nE "$PWD:t: $2"
	print -Pn "\a"
}

# string length ignoring ansi escapes
prompt_pure_string_length() {
	echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
}

prompt_pure_precmd() {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'

	# git info
	vcs_info

	local prompt_pure_preprompt="%F{green}\n$affirmation%f %F{yellow}`prompt_pure_cmd_exec_time`%f`p_colored_path` `p_vcs` "

	# check async if there is anything to pull
	(( ${PURE_GIT_PULL:-1} )) && {
		# check if we're in a git repo
		command git rev-parse --is-inside-work-tree &>/dev/null &&
		# make sure working tree is not $HOME
		[[ "$(command git rev-parse --show-toplevel)" != "$HOME" ]] &&
		# check check if there is anything to pull
		command git fetch &>/dev/null &&
		# check if there is an upstream configured for this branch
		command git rev-parse --abbrev-ref @'{u}' &>/dev/null && {
			(( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows='⇣'
			(( $(command git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows+='⇡'
		}
		# prompt_pure_preprompt+="$arrows"
	} &!

	print -P "$prompt_pure_preprompt"

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp
}

function zle-line-init zle-keymap-select {
	prompt_set
	zle reset-prompt
}

prompt_set() {
	local prompt_char

	case ${KEYMAP} in
		(vicmd)      prompt_char="»" ;;
		(main|viins) prompt_char="❯" ;;
		(*)          prompt_char="❯" ;;
	esac

	# prompt turns red if the previous command didn't exit with 0
	PROMPT="%(?.%F{cyan}.%F{red})$prompt_char%f "
}


prompt_pure_setup() {
	# prevent percentage showing up
	# if output doesn't end with a newline
	export PROMPT_EOL_MARK=''

	prompt_opts=(cr subst percent)

	zmodload zsh/datetime
	autoload -Uz add-zsh-hook
	# autoload -Uz vcs_info

	add-zsh-hook precmd prompt_pure_precmd
	add-zsh-hook preexec prompt_pure_preexec

	zle -N zle-line-init
	zle -N zle-keymap-select

	# zstyle ':vcs_info:*' enable git
	# zstyle ':vcs_info:git*' formats ' %b'
	# zstyle ':vcs_info:git*' actionformats ' %b|%a'
	
	prompt_set
}

prompt_pure_setup "$@"
