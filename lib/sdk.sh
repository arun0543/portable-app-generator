#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_SDK_SH:-}" ]]; then
	readonly _PAG_LIB_SDK_SH=1

	framework_require scaffold
	framework_require plugin_sdk
	framework_require template_sdk
	framework_require validator_sdk
	framework_require export
	framework_require logger
	framework_require validator

	# ==============================================================================
	# Module: SDK
	# Purpose: Top-level SDK coordinator.
	# Dependencies: scaffold, plugin_sdk, template_sdk, validator_sdk, export, logger, validator
	# Public API: sdk_init, sdk_create_plugin, sdk_create_template, sdk_validate, sdk_export
	# Private API: None
	# ==============================================================================

	# Initializes the SDK environment
	# Arguments: None
	# Returns: 0 on success, 1 on failure
	sdk_init() {
		log_debug "SDK initialized"
		# Future extension point: SDK upgrade checks, plugin marketplace sync
		return 0
	}

	# Creates a new plugin project via the Plugin SDK
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_create_plugin() {
		plugin_create "$@"
	}

	# Creates a new template project via the Template SDK
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_create_template() {
		template_create "$@"
	}

	# Validates an SDK project
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_validate() {
		local target_dir="$1"
		validate_required "${target_dir}" || return 1

		sdk_validate_project "${target_dir}" || return 1
		return 0
	}

	# Exports a project to an archive
	# Arguments:
	#   $1 - Target directory path
	#   $2 - Output archive path
	# Returns:
	#   0 on success, 1 on failure
	sdk_export() {
		local target_dir="$1"
		local output_archive="$2"

		validate_required "${target_dir}" || return 1
		validate_required "${output_archive}" || return 1

		sdk_validate "${target_dir}" || return 1
		export_project "${target_dir}" "${output_archive}" || return 1

		return 0
	}

fi
