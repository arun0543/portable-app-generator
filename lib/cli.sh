#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CLI_SH:-}" ]]; then
readonly _PAG_LIB_CLI_SH=1

framework_require parser
framework_require command
framework_require help
framework_require logger
framework_require config_cli
framework_require registry_cli

# ==============================================================================
# Module: CLI
# Purpose: Main CLI entry point and dispatcher.
# Dependencies: parser, command, help, logger, config_cli
# Public API: cli_main
# Private API: None
# ==============================================================================

# Main entry point for the CLI application
# Arguments:
#   $@ - Command line arguments
# Returns:
#   0 on success, >0 on failure
cli_main() {
	parser_parse_args "$@" || return 1

	if parser_get_flag "--debug"; then
		_PAG_LOG_LEVEL="DEBUG"
	elif parser_get_flag "--verbose" || parser_get_flag "-v"; then
		_PAG_LOG_LEVEL="INFO"
	fi

	if parser_get_flag "--help" || parser_get_flag "-h"; then
		help_print_global
		return 0
	fi

	local cmd
	if ! cmd="$(parser_get_command)"; then
		help_print_global
		return 1
	fi

	case "${cmd}" in
		help)
			local subcmd
			if subcmd="$(parser_get_subcommand)"; then
				help_print_command "${subcmd}"
			else
				help_print_global
			fi
			return 0
			;;
	esac

	if cli_is_command_registered "${cmd}"; then
		local handler="cmd_${cmd}"
		if declare -f "${handler}" >/dev/null; then
			"${handler}" "$@" || return 1
		else
			log_error "Handler for command ${cmd} not found."
			return 1
		fi
	else
		log_error "Unknown command: ${cmd}"
		help_print_global
		return 1
	fi

	return 0
}

fi
