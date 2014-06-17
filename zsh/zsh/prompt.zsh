# prompt
setopt prompt_subst

# mode-aware arrow

function p_arrow {
  if [[ $KEYMAP = "vicmd" ]]; then
    echo "%F{magenta}»%f"
  else
    echo "%F{cyan}»%f"
  fi
}

# colored path

function p_colored_path {
  local slash="%F{cyan}/%f"
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

function p_envs {
  local envs
	local ret
  [[ -n $SSH_CLIENT ]]  && envs+="♕ "
	[[ -z $SSH_CLIENT ]]  && envs+="♔ "
  [[ -n $VIRTUAL_ENV ]] && envs+="♘ "

  [[ -n $envs ]] && ret+="%F{red}$envs%f"
	[[ -n $SSH_CLIENT ]] && ret+=" %F{green}[%f`hostname`%F{green}]%f"
	echo $ret
}

PROMPT='
$(p_envs) $(p_colored_path)$(p_vcs) $(p_arrow) '

