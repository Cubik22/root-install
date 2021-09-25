# shellcheck shell=sh disable=SC1091,SC2039,SC2166
# Check for interactive bash and that we haven't already been sourced.
if [ "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ]; then
    # Check for recent enough version of bash.
	if [ "${BASH_VERSINFO[0]}" -gt 4 ] || [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 2 ]; then
		[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp ; then
	    	if [ -r /usr/share/bash-completion/bash_completion ]; then
        		# Source completion code
        	    . /usr/share/bash-completion/bash_completion
	    	fi
	    	if [ -r /usr/share/bash-completion/complete_alias ]; then
				# Source complete alias
				. /usr/share/bash-completion/complete_alias
	    	fi
	    	if [ -r /usr/share/bash-completion/completions/sudo ]; then
				# Source complete sudo (for doas)
				. /usr/share/bash-completion/completions/sudo
	    	fi
	    	if [ -r /usr/share/bash-completion/completions/git ]; then
				# Source complete git (for config)
				. /usr/share/bash-completion/completions/git
	    	fi
        fi
    fi
fi
