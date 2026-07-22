#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_COMPLETION_SH:-}" ]]; then
readonly _PAG_LIB_COMPLETION_SH=1

framework_require registry_cli

# ==============================================================================
# Module: Completion
# Purpose: Shell auto-completion script generation.
# Dependencies: None
# Public API: completion_generate_bash
# Private API: None
# ==============================================================================

# Generates the bash completion script to stdout
# Arguments: None
# Returns: 0
completion_generate_bash() {
	cat <<'EOF'
# PAG Bash Completion
_pag_completions() {
	local cur prev opts cmds
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	
	cmds="$(cli_get_registered_commands 2>/dev/null || true)"
	opts="${cmds//$'\n'/ }"
	
	case "${prev}" in
		new)
			COMPREPLY=( $(compgen -W "plugin template" -- "${cur}") )
			return 0
			;;
		help)
			COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
			return 0
			;;
	esac
	
	if [[ ${COMP_CWORD} -eq 1 ]]; then
		COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
		return 0
	fi
}
complete -F _pag_completions pag
EOF
	return 0
}

fi
