#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_PLUGIN_SH:-}" ]]; then
	readonly _PAG_LIB_PLUGIN_SH=1

	# ==============================================================================
	# Module: Plugin
	# Purpose: Manages plugin lifecycle and validation.
	# Dependencies: validator.sh, filesystem.sh, logger.sh
	# Public API: plugin_exists, plugin_list, plugin_validate, plugin_load
	# Private API: None
	# ==============================================================================

	# Checks if a plugin directory exists
	# Arguments:
	#   $1 - Plugin name
	# Returns:
	#   0 on success, 1 on failure
	plugin_exists() {
		local plugin_name="$1"
		validate_required "${plugin_name}" || return 1
		validate_required "${PAG_PLUGIN_DIR:-}" || return 1
		validate_directory "${PAG_PLUGIN_DIR}/${plugin_name}" || return 1
		return 0
	}

	# Lists all available plugins in the plugin directory
	# Arguments:
	#   None
	# Returns:
	#   0 on success, 1 on failure
	plugin_list() {
		validate_required "${PAG_PLUGIN_DIR:-}" || return 1
		validate_directory "${PAG_PLUGIN_DIR}" || return 1
		local d
		for d in "${PAG_PLUGIN_DIR}"/*; do
			if [[ -d "${d}" ]]; then
				basename "${d}"
			fi
		done
		return 0
	}

	# Validates that a plugin directory is structured correctly
	# Arguments:
	#   $1 - Plugin name
	# Returns:
	#   0 on success, 1 on failure
	plugin_validate() {
		local plugin_name="$1"
		plugin_exists "${plugin_name}" || return 1
		local plugin_file="${PAG_PLUGIN_DIR}/${plugin_name}/plugin.sh"
		validate_file "${plugin_file}" || return 1
		local metadata_file="${PAG_PLUGIN_DIR}/${plugin_name}/metadata.conf"
		validate_file "${metadata_file}" || return 1
		return 0
	}

	# Loads a plugin by sourcing its plugin.sh file
	# Arguments:
	#   $1 - Plugin name
	# Returns:
	#   0 on success, 1 on failure
	plugin_load() {
		local plugin_name="$1"
		plugin_validate "${plugin_name}" || return 1
		local plugin_file="${PAG_PLUGIN_DIR}/${plugin_name}/plugin.sh"

		log_debug "Loading plugin: ${plugin_name}"

		# shellcheck disable=SC1090
		source "${plugin_file}" || return 1
		return 0
	}

fi
