#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_TEMPLATE_SH:-}" ]]; then
readonly _PAG_LIB_TEMPLATE_SH=1

# ==============================================================================
# Module: Template
# Purpose: Basic template loading and rendering.
# Dependencies: filesystem.sh, validator.sh, logger.sh, sed, cat, mktemp, mv
# Public API: template_exists, template_load, template_render, template_write
# Private API: None
# ==============================================================================

# Checks if a template file exists
# Arguments:
#   $1 - Path to template file
# Returns:
#   0 if it exists, 1 otherwise
template_exists() {
	local template_path="$1"
	validate_required "${template_path}" || return 1
	validate_file "${template_path}" || return 1
	return 0
}

# Loads and prints the raw contents of a template file
# Arguments:
#   $1 - Path to template file
# Returns:
#   0 on success, 1 on failure
template_load() {
	local template_path="$1"
	template_exists "${template_path}" || return 1
	cat "${template_path}" || return 1
	return 0
}

# Renders a template by replacing placeholders with supplied key/value pairs
# Safely escapes replacement values to handle special characters.
# Assumption: Placeholder keys should be restricted to simple character
# sets (e.g., [A-Z0-9_]+) to avoid regex metacharacter issues.
# Arguments:
#   $1 - Path to template file
#   $2.. - Key/Value pairs (e.g., KEY1 VALUE1 KEY2 VALUE2)
# Returns:
#   0 on success, 1 on failure
template_render() {
	local template_path="$1"
	shift

	template_exists "${template_path}" || return 1

	local sed_script=""
	local key val escaped_val
	while [[ $# -gt 1 ]]; do
		key="$1"
		val="$2"
		shift 2

		# Safely escape replacement values for sed substitution
		# 1. Escape backslash (\)
		escaped_val="${val//\\/\\\\}"
		# 2. Escape forward slash (/)
		escaped_val="${escaped_val//\//\\/}"
		# 3. Escape dollar sign ($)
		escaped_val="${escaped_val//\$/\\\$}"
		# 4. Escape ampersand (&)
		escaped_val="${escaped_val//&/\\&}"

		sed_script+="s/{{${key}}}/${escaped_val}/g; "
	done

	if [[ -z "${sed_script}" ]]; then
		cat "${template_path}"
	else
		sed -e "${sed_script}" "${template_path}" || return 1
	fi

	return 0
}

# Renders a template and writes the output atomically to a destination file
# Arguments:
#   $1 - Path to template file
#   $2 - Destination file path
#   $3.. - Key/Value pairs
# Returns:
#   0 on success, 1 on failure
template_write() {
	local template_path="$1"
	local dest_path="$2"
	shift 2

	validate_required "${dest_path}" || return 1

	log_debug "Writing template ${template_path} to ${dest_path}"

	local tmp_file
	tmp_file="$(mktemp)" || return 1
	trap 'rm -f "${tmp_file}"' RETURN

	template_render "${template_path}" "$@" >"${tmp_file}" || return 1
	mv -f "${tmp_file}" "${dest_path}" || return 1

	return 0
}

fi
