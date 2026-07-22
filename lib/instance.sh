#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_INSTANCE_SH:-}" ]]; then
readonly _PAG_LIB_INSTANCE_SH=1

# ==============================================================================
# Module: Instance
# Purpose: Manages instance directories and associated metadata.
# Dependencies: filesystem.sh, metadata.sh, validator.sh, logger.sh
# Public API: instance_exists, instance_create, instance_remove, instance_list
# Private API: None
# ==============================================================================

readonly PAG_METADATA_FILE="metadata.conf"

# Checks if an instance directory and its metadata file exist
# Arguments:
#   $1 - Path to the instance directory
# Returns:
#   0 if both exist, 1 otherwise
instance_exists() {
	local instance_dir="$1"
	validate_required "${instance_dir}" || return 1
	fs_is_dir "${instance_dir}" || return 1
	local meta_file="${instance_dir}/${PAG_METADATA_FILE}"
	fs_is_file "${meta_file}" || return 1
	return 0
}

# Creates a new instance directory and its metadata file
# Arguments:
#   $1 - Path to the instance directory
# Returns:
#   0 on success, 1 on failure
instance_create() {
	local instance_dir="$1"
	validate_required "${instance_dir}" || return 1

	log_debug "Creating instance at ${instance_dir}"

	if instance_exists "${instance_dir}"; then
		return 0
	fi

	# 1. Create directory
	fs_create_dir "${instance_dir}" || return 1

	# 2. Create metadata file (empty is acceptable)
	local meta_file="${instance_dir}/${PAG_METADATA_FILE}"
	printf '' >"${meta_file}" || return 1

	# 3. Verify creation
	instance_exists "${instance_dir}" || return 1

	# 4. Return
	return 0
}

# Removes an existing instance directory
# Arguments:
#   $1 - Path to the instance directory
# Returns:
#   0 on success, 1 on failure
instance_remove() {
	local instance_dir="$1"
	validate_required "${instance_dir}" || return 1

	log_debug "Removing instance at ${instance_dir}"

	instance_exists "${instance_dir}" || return 1
	fs_remove "${instance_dir}" || return 1

	return 0
}

# Lists all valid instances within a base directory
# Arguments:
#   $1 - Path to the base instances directory
# Returns:
#   0 on success, 1 on failure
instance_list() {
	local base_dir="$1"
	validate_required "${base_dir}" || return 1
	validate_directory "${base_dir}" || return 1

	local d
	for d in "${base_dir}"/*; do
		if [[ -d "${d}" ]]; then
			if instance_exists "${d}"; then
				basename "${d}"
			fi
		fi
	done

	return 0
}

fi
