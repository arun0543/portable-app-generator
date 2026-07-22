#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_COMPATIBILITY_SH:-}" ]]; then
	readonly _PAG_LIB_COMPATIBILITY_SH=1

	framework_require manifest
	framework_require logger
	framework_require validator

	# ==============================================================================
	# Module: Compatibility
	# Purpose: Framework compatibility management.
	# Dependencies: manifest, logger, validator
	# Public API: framework_version, plugin_api_version, compatibility_check
	# Private API: None
	# ==============================================================================

	readonly PAG_FRAMEWORK_API_VERSION="1.0.0"

	# Outputs the current framework API version
	# Arguments: None
	# Returns: 0 on success
	framework_version() {
		printf '%s\n' "${PAG_FRAMEWORK_API_VERSION}"
		return 0
	}

	# Outputs the requested plugin API version from its manifest
	# Arguments:
	#   $1 - Path to manifest file
	# Returns:
	#   0 on success, 1 on failure
	plugin_api_version() {
		local manifest_file="$1"
		validate_required "${manifest_file}" || return 1

		manifest_read "${manifest_file}" "api_version" || return 1
		return 0
	}

	# Validates if a plugin is compatible with the current framework
	# Arguments:
	#   $1 - Path to manifest file
	# Returns:
	#   0 on success, 1 on failure
	compatibility_check() {
		local manifest_file="$1"
		validate_required "${manifest_file}" || return 1

		local framework_api plugin_api
		framework_api=$(framework_version) || return 1
		plugin_api=$(plugin_api_version "${manifest_file}") || return 1

		if [[ -z "${plugin_api}" ]]; then
			log_error "Plugin API version not found in ${manifest_file}"
			return 1
		fi

		log_debug "Checking compatibility: Framework API ${framework_api} vs Plugin API ${plugin_api}"

		# Future extension point: Rich Semantic Versioning negotiation
		if [[ "${plugin_api}" != "${framework_api}" ]]; then
			local plugin_major="${plugin_api%%.*}"
			local framework_major="${framework_api%%.*}"

			if [[ "${plugin_major}" != "${framework_major}" ]]; then
				log_error "Incompatible API version! Plugin: ${plugin_api}, Framework: ${framework_api}"
				return 1
			fi
		fi

		return 0
	}

fi
