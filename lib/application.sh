#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_APPLICATION_SH:-}" ]]; then
readonly _PAG_LIB_APPLICATION_SH=1

framework_require instance
framework_require filesystem
framework_require metadata
framework_require logger
framework_require validator

# ==============================================================================
# Module: Application
# Purpose: Manage application instances and their directory structure.
# Dependencies: instance, filesystem, metadata, logger
# Public API: application_create, application_remove, application_verify, application_info
# Private API: None
# ==============================================================================

readonly PAG_APP_DIRECTORIES=("app" "config" "data" "cache" "runtime" "logs" "launcher" "desktop")

# Creates the foundational directory tree for an application
# Arguments:
#   $1 - Instance directory path
# Returns:
#   0 on success, 1 on failure
application_create() {
	local instance_dir="$1"
	validate_required "${instance_dir}" || return 1

	log_debug "Creating application instance at ${instance_dir}"

	instance_create "${instance_dir}" || return 1

	local dir
	for dir in "${PAG_APP_DIRECTORIES[@]}"; do
		fs_create_dir "${instance_dir}/${dir}" || return 1
	done

	return 0
}

# Removes an application instance and its structure
# Arguments:
#   $1 - Instance directory path
# Returns:
#   0 on success, 1 on failure
application_remove() {
	local instance_dir="$1"
	validate_required "${instance_dir}" || return 1

	log_debug "Removing application instance at ${instance_dir}"
	instance_remove "${instance_dir}" || return 1
	return 0
}

# Verifies the integrity of an application instance directory tree
# Arguments:
#   $1 - Instance directory path
# Returns:
#   0 on success, 1 on failure
application_verify() {
	local instance_dir="$1"
	validate_required "${instance_dir}" || return 1

	instance_exists "${instance_dir}" || return 1

	local dir
	for dir in "${PAG_APP_DIRECTORIES[@]}"; do
		fs_is_dir "${instance_dir}/${dir}" || return 1
	done

	# Future extension point: Deep application repair and self-healing checks
	return 0
}

# Retrieves application metadata information
# Arguments:
#   $1 - Instance directory path
#   $2 - Metadata key
# Returns:
#   0 on success, 1 on failure
application_info() {
	local instance_dir="$1"
	local key="$2"
	validate_required "${instance_dir}" || return 1
	validate_required "${key}" || return 1

	# Fallback metadata file name if PAG_METADATA_FILE is unset in this scope
	local meta_file="${instance_dir}/${PAG_METADATA_FILE:-metadata.conf}"
	metadata_read "${meta_file}" "${key}" || return 1
	return 0
}

fi
