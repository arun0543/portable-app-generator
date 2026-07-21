#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_PARSER_SH:-}" ]]; then
readonly _PAG_LIB_PARSER_SH=1

# ==============================================================================
# Module: Parser
# Purpose: Command-line argument parsing and state management.
# Dependencies: None
# Public API: parser_parse_args, parser_get_flag, parser_get_option, parser_get_positional, parser_get_command, parser_get_subcommand
# Private API: None
# ==============================================================================

declare -a _PAG_CLI_POSITIONAL=()
declare -A _PAG_CLI_FLAGS=()
declare -A _PAG_CLI_OPTIONS=()
_PAG_CLI_COMMAND=""
_PAG_CLI_SUBCOMMAND=""

# Parses command line arguments into internal state
# Arguments:
#   $@ - All script arguments
# Returns:
#   0 on success, 1 on failure
parser_parse_args() {
	_PAG_CLI_POSITIONAL=()
	_PAG_CLI_FLAGS=()
	_PAG_CLI_OPTIONS=()
	_PAG_CLI_COMMAND=""
	_PAG_CLI_SUBCOMMAND=""

	local is_command=0

	while [[ $# -gt 0 ]]; do
		local arg="$1"

		case "${arg}" in
			--*=*)
				local key="${arg%%=*}"
				local val="${arg#*=}"
				_PAG_CLI_OPTIONS["${key}"]="${val}"
				;;
			--*)
				# Check if next argument is a value or another flag
				if [[ $# -gt 1 && ! "$2" == -* ]]; then
					_PAG_CLI_OPTIONS["${arg}"]="$2"
					shift
				else
					_PAG_CLI_FLAGS["${arg}"]="true"
				fi
				;;
			-*)
				# Short flags, treated as boolean or combined booleans
				local flags="${arg#-}"
				if [[ "${flags}" == *=* ]]; then
					local key="-${flags%%=*}"
					local val="${flags#*=}"
					_PAG_CLI_OPTIONS["${key}"]="${val}"
				else
					local i
					for (( i=0; i<${#flags}; i++ )); do
						local f="${flags:$i:1}"
						_PAG_CLI_FLAGS["-${f}"]="true"
					done
				fi
				;;
			*)
				if [[ "${is_command}" -eq 0 ]]; then
					_PAG_CLI_COMMAND="${arg}"
					is_command=1
				elif [[ "${is_command}" -eq 1 && -z "${_PAG_CLI_SUBCOMMAND}" ]]; then
					_PAG_CLI_SUBCOMMAND="${arg}"
					_PAG_CLI_POSITIONAL+=("${arg}")
				else
					_PAG_CLI_POSITIONAL+=("${arg}")
				fi
				;;
		esac
		shift
	done

	return 0
}

# Checks if a boolean flag was passed
# Arguments:
#   $1 - Flag to check (e.g., --verbose)
# Returns:
#   0 if flag is present, 1 otherwise
parser_get_flag() {
	local flag="$1"
	[[ "${_PAG_CLI_FLAGS[${flag}]:-}" == "true" ]]
}

# Gets the string value of an option flag
# Arguments:
#   $1 - Option flag (e.g., --output)
# Returns:
#   0 and prints value on success, 1 otherwise
parser_get_option() {
	local option="$1"
	if [[ -n "${_PAG_CLI_OPTIONS[${option}]:-}" ]]; then
		printf '%s\n' "${_PAG_CLI_OPTIONS[${option}]}"
		return 0
	fi
	return 1
}

# Gets a positional argument by index
# Arguments:
#   $1 - Zero-based index of the positional argument
# Returns:
#   0 and prints value on success, 1 otherwise
parser_get_positional() {
	local index="$1"
	if [[ ${index} -lt ${#_PAG_CLI_POSITIONAL[@]} ]]; then
		printf '%s\n' "${_PAG_CLI_POSITIONAL[${index}]}"
		return 0
	fi
	return 1
}

# Gets the primary command parsed
# Returns:
#   0 and prints command on success, 1 otherwise
parser_get_command() {
	if [[ -n "${_PAG_CLI_COMMAND}" ]]; then
		printf '%s\n' "${_PAG_CLI_COMMAND}"
		return 0
	fi
	return 1
}

# Gets the parsed subcommand (which is also the first positional)
# Returns:
#   0 and prints subcommand on success, 1 otherwise
parser_get_subcommand() {
	if [[ -n "${_PAG_CLI_SUBCOMMAND}" ]]; then
		printf '%s\n' "${_PAG_CLI_SUBCOMMAND}"
		return 0
	fi
	return 1
}

fi
