#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_RUNTIME_SH:-}" ]]; then
readonly _PAG_LIB_RUNTIME_SH=1

# ==============================================================================
# Module: Runtime
# Purpose: Manage framework runtime directories and state.
# Dependencies: filesystem, logger
# Public API: runtime_init, runtime_shutdown, runtime_reset
# Private API: None
# ==============================================================================

# Global Framework State Variables
readonly PAG_RUNTIME_STATE_READY="ready"
readonly PAG_RUNTIME_STATE_STOPPED="stopped"

# _PAG_RUNTIME_STATE: Tracks the current runtime lifecycle state
_PAG_RUNTIME_STATE="${PAG_RUNTIME_STATE_STOPPED}"

# Initializes framework runtime directories and state
# Arguments:
#   None
# Returns:
#   0 on success, 1 on failure
runtime_init() {
	local runtime_dir="${PAG_RUNTIME_DIR:-/tmp/pag_runtime}"
	fs_create_dir "${runtime_dir}" || return 1
	_PAG_RUNTIME_STATE="${PAG_RUNTIME_STATE_READY}"
	log_debug "Runtime initialized at ${runtime_dir}"
	return 0
}

# Safely shuts down the framework runtime and cleans up temporary files
# Keeps the runtime root directory intact.
# Arguments:
#   None
# Returns:
#   0 on success, 1 on failure
runtime_shutdown() {
	local runtime_dir="${PAG_RUNTIME_DIR:-/tmp/pag_runtime}"
	if fs_exists "${runtime_dir}"; then
		# Clean runtime contents but keep root directory
		local item
		for item in "${runtime_dir}"/* "${runtime_dir}"/.[!.]* "${runtime_dir}"/..?*; do
			if [[ -e "${item}" || -h "${item}" ]]; then
				fs_remove "${item}" || return 1
			fi
		done
		log_debug "Runtime shutdown and cleaned up contents of ${runtime_dir}"
	fi
	_PAG_RUNTIME_STATE="${PAG_RUNTIME_STATE_STOPPED}"
	return 0
}

# Resets the framework runtime
# Arguments:
#   None
# Returns:
#   0 on success, 1 on failure
runtime_reset() {
	runtime_shutdown || return 1
	runtime_init || return 1
	return 0
}

fi
