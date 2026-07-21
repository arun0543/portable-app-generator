#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_ERROR_SH:-}" ]]; then
readonly _PAG_LIB_ERROR_SH=1

# ==============================================================================
# Module: Error
# Purpose: Central error manager.
# Dependencies: None
# Public API: error_set, error_clear, error_last
# Private API: None
# ==============================================================================

# Global Framework State Variables
# _PAG_LAST_ERROR: Stores the latest framework error message
_PAG_LAST_ERROR=""

# Sets the latest framework error message
# Arguments:
#   $@ - Error message string
# Returns:
#   0 on success
error_set() {
	local msg="$*"
	_PAG_LAST_ERROR="${msg}"
	return 0
}

# Clears the latest framework error message
# Arguments:
#   None
# Returns:
#   0 on success
error_clear() {
	_PAG_LAST_ERROR=""
	return 0
}

# Retrieves and prints the latest framework error message
# Arguments:
#   None
# Returns:
#   0 on success if an error exists, 1 if no error is set
error_last() {
	if [[ -z "${_PAG_LAST_ERROR}" ]]; then
		return 1
	fi
	printf '%s\n' "${_PAG_LAST_ERROR}"
	return 0
}

fi
