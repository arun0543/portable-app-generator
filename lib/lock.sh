#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_LOCK_SH:-}" ]]; then
	readonly _PAG_LIB_LOCK_SH=1

	# ==============================================================================
	# Module: Lock
	# Purpose: Framework locking to prevent duplicate execution.
	# Dependencies: filesystem, logger
	# Public API: lock_exists, lock_acquire, lock_release
	# Private API: None
	# ==============================================================================

	# Checks if a lock file exists
	# Arguments:
	#   $1 - Path to lock file
	# Returns:
	#   0 if locked, 1 otherwise
	lock_exists() {
		local lock_file="$1"
		fs_exists "${lock_file}" || return 1
		return 0
	}

	# Atomically acquires a lock and writes the current PID
	# Arguments:
	#   $1 - Path to lock file
	# Returns:
	#   0 on success, 1 on failure
	lock_acquire() {
		local lock_file="$1"

		if lock_exists "${lock_file}"; then
			log_warn "Lock already exists: ${lock_file}"
			return 1
		fi

		log_debug "Acquiring lock: ${lock_file}"

		if (
			set -o noclobber
			printf '%s\n' "$$" >"${lock_file}"
		) 2>/dev/null; then
			return 0
		else
			return 1
		fi
	}

	# Releases a lock file safely
	# Arguments:
	#   $1 - Path to lock file
	# Returns:
	#   0 on success, 1 on failure
	lock_release() {
		local lock_file="$1"

		if lock_exists "${lock_file}"; then
			log_debug "Releasing lock: ${lock_file}"
			fs_remove "${lock_file}" || return 1
		fi

		return 0
	}

fi
