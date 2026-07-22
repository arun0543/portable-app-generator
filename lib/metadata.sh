#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_METADATA_SH:-}" ]]; then
readonly _PAG_LIB_METADATA_SH=1

# ==============================================================================
# Module: Metadata
# Purpose: Manages instance metadata storage.
# Dependencies: config.sh
# Public API: metadata_exists, metadata_read, metadata_write, metadata_remove
# Private API: None
# ==============================================================================

# Checks if a metadata key exists in the specified metadata file
# Arguments:
#   $1 - Path to the metadata file
#   $2 - Metadata key
# Returns:
#   0 if exists, 1 otherwise
metadata_exists() {
	config_exists "$@"
}

# Reads the value of a metadata key from the specified file
# Arguments:
#   $1 - Path to the metadata file
#   $2 - Metadata key
# Returns:
#   0 on success, 1 on failure
metadata_read() {
	config_read "$@"
}

# Writes a metadata key and value to the specified file
# Arguments:
#   $1 - Path to the metadata file
#   $2 - Metadata key
#   $3 - Metadata value
#   $4 - (Optional) Set to "true" to overwrite
# Returns:
#   0 on success, 1 on failure
metadata_write() {
	config_write "$@"
}

# Removes a metadata key from the specified file
# Arguments:
#   $1 - Path to the metadata file
#   $2 - Metadata key to remove
# Returns:
#   0 on success, 1 on failure
metadata_remove() {
	config_remove "$@"
}

fi
