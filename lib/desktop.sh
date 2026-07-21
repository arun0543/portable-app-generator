#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_DESKTOP_SH:-}" ]]; then
readonly _PAG_LIB_DESKTOP_SH=1

framework_require template
framework_require filesystem
framework_require launcher
framework_require logger
framework_require validator

# ==============================================================================
# Module: Desktop
# Purpose: Desktop integration.
# Dependencies: template, filesystem, launcher, logger
# Public API: desktop_generate, desktop_remove, desktop_verify
# Private API: None
# ==============================================================================

# Generates desktop entry from a template
# Arguments:
#   $1 - Template path
#   $2 - Destination .desktop file path
#   $@ - Template replacement variables
# Returns:
#   0 on success, 1 on failure
desktop_generate() {
	local template_path="$1"
	local desktop_file="$2"
	shift 2

	validate_required "${template_path}" || return 1
	validate_required "${desktop_file}" || return 1

	log_debug "Generating desktop entry at ${desktop_file}"

	# Future extension point: Advanced icon links, categories, menu integrations
	template_write "${template_path}" "${desktop_file}" "$@" || return 1

	return 0
}

# Removes a desktop entry
# Arguments:
#   $1 - Destination .desktop file path
# Returns:
#   0 on success, 1 on failure
desktop_remove() {
	local desktop_file="$1"
	validate_required "${desktop_file}" || return 1

	if fs_exists "${desktop_file}"; then
		log_debug "Removing desktop entry ${desktop_file}"
		fs_remove "${desktop_file}" || return 1
	fi

	return 0
}

# Verifies a desktop entry exists
# Arguments:
#   $1 - Destination .desktop file path
# Returns:
#   0 on success, 1 on failure
desktop_verify() {
	local desktop_file="$1"
	validate_required "${desktop_file}" || return 1

	fs_exists "${desktop_file}" || return 1

	return 0
}

fi
