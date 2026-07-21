#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_PLUGIN_SDK_SH:-}" ]]; then
readonly _PAG_LIB_PLUGIN_SDK_SH=1

framework_require scaffold
framework_require validator_sdk
framework_require export
framework_require logger
framework_require validator

# ==============================================================================
# Module: Plugin SDK
# Purpose: Plugin development SDK functionality.
# Dependencies: scaffold, validator_sdk, export, logger, validator
# Public API: plugin_create, plugin_validate, plugin_build
# Private API: None
# ==============================================================================

# Creates a new plugin project
# Arguments:
#   $1 - Target directory path
# Returns:
#   0 on success, 1 on failure
plugin_create() {
	local target_dir="$1"
	validate_required "${target_dir}" || return 1

	scaffold_plugin "${target_dir}" || return 1

	log_debug "Plugin created at ${target_dir}"
	return 0
}

# Validates a plugin project layout
# Arguments:
#   $1 - Target directory path
# Returns:
#   0 on success, 1 on failure
plugin_validate() {
	local target_dir="$1"
	validate_required "${target_dir}" || return 1

	sdk_validate_plugin "${target_dir}" || return 1

	log_debug "Plugin validated at ${target_dir}"
	return 0
}

# Validates and builds a plugin package
# Arguments:
#   $1 - Target directory path
#   $2 - Output archive path
# Returns:
#   0 on success, 1 on failure
plugin_build() {
	local target_dir="$1"
	local output_archive="$2"

	validate_required "${target_dir}" || return 1
	validate_required "${output_archive}" || return 1

	plugin_validate "${target_dir}" || return 1
	export_plugin "${target_dir}" "${output_archive}" || return 1

	log_debug "Plugin built at ${output_archive}"
	return 0
}

fi
