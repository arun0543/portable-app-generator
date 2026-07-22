#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_TEMPLATE_SDK_SH:-}" ]]; then
readonly _PAG_LIB_TEMPLATE_SDK_SH=1

framework_require scaffold
framework_require validator_sdk
framework_require export
framework_require logger
framework_require validator

# ==============================================================================
# Module: Template SDK
# Purpose: Template development SDK functionality.
# Dependencies: scaffold, validator_sdk, export, logger, validator
# Public API: template_create, template_validate, template_build
# Private API: None
# ==============================================================================

# Creates a new template project
# Arguments:
#   $1 - Target directory path
# Returns:
#   0 on success, 1 on failure
template_create() {
	local target_dir="$1"
	validate_required "${target_dir}" || return 1

	scaffold_template "${target_dir}" || return 1

	log_debug "Template created at ${target_dir}"
	return 0
}

# Validates a template project layout
# Arguments:
#   $1 - Target directory path
# Returns:
#   0 on success, 1 on failure
template_validate() {
	local target_dir="$1"
	validate_required "${target_dir}" || return 1

	sdk_validate_template "${target_dir}" || return 1

	log_debug "Template validated at ${target_dir}"
	return 0
}

# Validates and builds a template package
# Arguments:
#   $1 - Target directory path
#   $2 - Output archive path
# Returns:
#   0 on success, 1 on failure
template_build() {
	local target_dir="$1"
	local output_archive="$2"

	validate_required "${target_dir}" || return 1
	validate_required "${output_archive}" || return 1

	template_validate "${target_dir}" || return 1
	export_template "${target_dir}" "${output_archive}" || return 1

	log_debug "Template built at ${output_archive}"
	return 0
}

fi
