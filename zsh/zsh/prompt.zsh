# prompt
setopt prompt_subst

function p_rook {
	echo "%F{red}♜%f"
}

# colored path

function p_colored_path {
  local slash="${BLUE}/${RESET}"
  echo "${${PWD/#$HOME/~}//\//$slash}"
}

# git info

function p_vcs {
  vcs_info
  echo $vcs_info_msg_0_
}

# environments:
#  - ssh
#  - virtualenv
#  - cabal sandbox

export VIRTUAL_ENV_DISABLE_PROMPT=1

function p_host {
	local host
	if [[ -n $HOST_SYMBOL ]]; then
		echo "${RED}${HOST_SYMBOL}${RESET} " 	
	else
		echo "${RED}♘${RESET} ${BOLD}${ORANGE}`hostname`${RESET}"
	fi
}

function p_time {
	echo "${YELLOW}`date +%H:%M`${RESET}"
}

PROMPT='
┌─ $(p_host) $(p_time) $(p_colored_path)$(p_vcs)
└─ $(p_rook)  '
