# vcsinfo: thanks to github.com/sunaku/home/
autoload -Uz vcs_info

VCS_PROMPT="${VIOLET}%b${RESET}${RED}%u${RESET}${GREEN}%c${RESET}%m"
AVCS_PROMPT="$VCS_PROMPT ${BLUE}%a${RESET}"

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "-"
zstyle ':vcs_info:*' formats $VCS_PROMPT
zstyle ':vcs_info:*' actionformats $AVCS_PROMPT
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks git-aheadbehind git-untracked git-message

### git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
# Make sure you have added misc to your 'formats':	%m
function +vi-git-aheadbehind() {
	local ahead behind
	local -a gitstatus

	behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
	(( $behind )) && gitstatus+=( "[-${RED}${behind}${RESET}]" )

	ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
	(( $ahead )) && gitstatus+=( "[+${BLUE}${ahead}${RESET}]" )

	hook_com[misc]+=${(j::)gitstatus}

	if [[ -n ${hook_com[misc]} ]]; then
		hook_com[misc]=" ${hook_com[misc]}"
	fi
}

### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats':	%c
function +vi-git-untracked(){
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		# This will show the marker if there are any untracked files in repo.
		hook_com[branch]="${MAGENTA}.${RESET}${VIOLET}${SITM}${hook_com[branch]}${RITM}${RESET}"
	fi
}

# proper spacing
function +vi-git-message(){
	if [[ -n ${hook_com[unstaged]} ]]; then
		if [[ -n ${hook_com[staged]} ]]; then
			hook_com[unstaged]="+"
			hook_com[staged]="-"
		else
			hook_com[unstaged]="${hook_com[unstaged]}"
		fi
	else
		if [[ -n ${hook_com[staged]} ]]; then
			hook_com[staged]="${hook_com[staged]}"
		fi
	fi
}
