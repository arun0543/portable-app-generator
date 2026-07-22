#!/usr/bin/env bash
#
# Portable App Generator (PAG) - Main Entry Point
#
# @description Bootstraps and executes the Portable App Generator.
# @shell shellcheck compliant
#

set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Globals and Constants
# ==============================================================================

readonly PAG_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PAG_VERSION_FILE="${PAG_ROOT}/VERSION"
readonly PAG_LIB="${PAG_ROOT}/lib"
readonly PAG_PLUGIN_DIR="${PAG_ROOT}/plugins"
readonly PAG_TEMPLATE_DIR="${PAG_ROOT}/templates"
readonly PAG_INSTANCE_DIR="${PAG_ROOT}/instances"
readonly PAG_LOG_DIR="${PAG_ROOT}/logs"

# ==============================================================================
# Functions
# ==============================================================================

# ------------------------------------------------------------------------------
# @description Outputs the current version of the generator.
# @return 0 on success.
# ------------------------------------------------------------------------------
get_version() {
	cat "${PAG_VERSION_FILE}"
}

# ------------------------------------------------------------------------------
# @description Initializes the application context.
# @return 0 on success, 1 on failure.
# ------------------------------------------------------------------------------
bootstrap() {
	verify_structure || return 1
	load_framework || return 1
	return 0
}

# ------------------------------------------------------------------------------
# @description Loads the core framework library modules.
# @return 0 on success.
# ------------------------------------------------------------------------------
load_framework() {
	# shellcheck disable=SC1091
	[[ -f "${PAG_LIB}/logger.sh" ]] && source "${PAG_LIB}/logger.sh"

	return 0
}

# ------------------------------------------------------------------------------
# @description Validates the existence of required directories.
# @return 0 on success, 1 on failure.
# ------------------------------------------------------------------------------
verify_structure() {
	local dir
	for dir in "${PAG_LIB}" "${PAG_PLUGIN_DIR}" "${PAG_TEMPLATE_DIR}" "${PAG_INSTANCE_DIR}" "${PAG_LOG_DIR}"; do
		if [[ ! -d "${dir}" ]]; then
			printf "Error: Required directory '%s' is missing.\n" "${dir}" >&2
			return 1
		fi
	done
	return 0
}

# ------------------------------------------------------------------------------
# @description Parses command-line arguments.
# @param "$@" Command line arguments.
# @return 0 on success, 1 on error.
# ------------------------------------------------------------------------------
parse_cli() {
	if [[ "$#" -eq 0 ]]; then
		printf "Usage: ./generator.sh [options]\n"
		return 0
	fi

	local arg
	for arg in "$@"; do
		case "${arg}" in
			-h | --help)
				printf "Usage: ./generator.sh [options]\n"
				return 0
				;;
			-v | --version)
				printf "PAG Version: %s\n" "$(get_version)"
				return 0
				;;
			*)
				printf "Error: Unknown argument '%s'\n" "${arg}" >&2
				return 1
				;;
		esac
	done
	return 0
}

# ------------------------------------------------------------------------------
# @description Dispatches the parsed commands to their respective handlers.
# @return 0 on success.
# ------------------------------------------------------------------------------
dispatch() {
	return 0
}

# ------------------------------------------------------------------------------
# @description Performs cleanup tasks before exiting.
# @return 0 on success.
# ------------------------------------------------------------------------------
shutdown() {
	return 0
}

# ------------------------------------------------------------------------------
# @description Main execution flow.
# @param "$@" Command line arguments.
# @return 0 on success, non-zero on failure.
# ------------------------------------------------------------------------------
main() {
	bootstrap || return 1
	parse_cli "$@" || return 1
	dispatch || return 1
	shutdown || return 1
	return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	main "$@"
fi
