#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_MANIFEST_SH:-}" ]]; then
readonly _PAG_LIB_MANIFEST_SH=1

framework_require config
framework_require validator
framework_require logger

# ==============================================================================
# Module: Manifest
# Purpose: Manage plugin manifests.
# Dependencies: config, validator, logger
# Public API: manifest_exists, manifest_load, manifest_validate, manifest_read
# Private API: None
# ==============================================================================

# Required manifest keys
readonly PAG_MANIFEST_REQUIRED_KEYS=("name" "version" "api_version" "author" "description")

# Checks if a manifest file exists
# Arguments:
#   $1 - Path to manifest file
# Returns:
#   0 on success, 1 on failure
manifest_exists() {
	local manifest_file="$1"
	validate_required "${manifest_file}" || return 1
	config_exists "${manifest_file}" || return 1
	return 0
}

# Loads and validates a manifest file
# Arguments:
#   $1 - Path to manifest file
# Returns:
#   0 on success, 1 on failure
manifest_load() {
	local manifest_file="$1"
	validate_required "${manifest_file}" || return 1
	manifest_validate "${manifest_file}" || return 1
	return 0
}

# Validates that a manifest contains all required keys
# Arguments:
#   $1 - Path to manifest file
# Returns:
#   0 on success, 1 on failure
manifest_validate() {
	local manifest_file="$1"
	validate_required "${manifest_file}" || return 1
	manifest_exists "${manifest_file}" || return 1

	local key val
	for key in "${PAG_MANIFEST_REQUIRED_KEYS[@]}"; do
		val=""
		val="$(config_read "${manifest_file}" "${key}")" || {
			log_error "Manifest validation failed: missing key '${key}' in ${manifest_file}"
			return 1
		}
		if [[ -z "${val}" ]]; then
			log_error "Manifest validation failed: empty key '${key}' in ${manifest_file}"
			return 1
		fi
	done

	# Future extension point: validate values (e.g. version formats)
	return 0
}

# Reads a specific key from a manifest file
# Arguments:
#   $1 - Path to manifest file
#   $2 - Key to read
# Returns:
#   0 on success, 1 on failure
manifest_read() {
	local manifest_file="$1"
	local key="$2"
	validate_required "${manifest_file}" || return 1
	validate_required "${key}" || return 1

	config_read "${manifest_file}" "${key}" || return 1
	return 0
}

fi
