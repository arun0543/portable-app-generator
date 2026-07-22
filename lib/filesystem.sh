#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_FILESYSTEM_SH:-}" ]]; then
	readonly _PAG_LIB_FILESYSTEM_SH=1

	# ==============================================================================
	# Module: Filesystem
	# Purpose: Provides safe helper functions for filesystem operations.
	# Dependencies: mkdir, rm, cp, mv
	# Public API: fs_exists, fs_is_file, fs_is_dir, fs_create_dir, fs_remove, fs_copy, fs_move, fs_make_executable
	# Private API: _fs_is_safe_path
	# ==============================================================================

	# Internal helper to validate if a path is safe to modify or delete.
	# Rejects empty paths, literal /, ., .., ~, and relative traversals.
	# Fixes ineffective "/*" check by rejecting globs or dangerous roots.
	# Arguments:
	#   $1 - Path to validate
	# Returns:
	#   0 if safe, 1 otherwise
	_fs_is_safe_path() {
		local target="$1"

		# Reject empty
		[[ -z "${target}" ]] && return 1

		# Reject literal dangerous characters/paths
		case "${target}" in
		/ | . | .. | ~) return 1 ;;
		esac

		# Reject relative traversal
		if [[ "${target}" == *"../"* || "${target}" == *"/.." || "${target}" == "../" ]]; then
			return 1
		fi

		# Reject wildcards and ineffective "/*" scenarios
		if [[ "${target}" == *\** || "${target}" == *\?* ]]; then
			return 1
		fi

		# Reject paths starting with "~/"
		# shellcheck disable=SC2088
		if [[ "${target}" == "~/"* || "${target}" == "~" ]]; then
			return 1
		fi

		return 0
	}

	# Checks if a path exists.
	# Arguments:
	#   $1 - Path to check
	# Returns:
	#   0 if path exists, 1 otherwise
	fs_exists() {
		local target="$1"
		[[ -n "${target}" ]] || return 1
		[[ -e "${target}" ]] || return 1
		return 0
	}

	# Checks if a path is a regular file.
	# Arguments:
	#   $1 - Path to check
	# Returns:
	#   0 if path is a file, 1 otherwise
	fs_is_file() {
		local target="$1"
		[[ -n "${target}" ]] || return 1
		[[ -f "${target}" ]] || return 1
		return 0
	}

	# Checks if a path is a directory.
	# Arguments:
	#   $1 - Path to check
	# Returns:
	#   0 if path is a directory, 1 otherwise
	fs_is_dir() {
		local target="$1"
		[[ -n "${target}" ]] || return 1
		[[ -d "${target}" ]] || return 1
		return 0
	}

	# Safely creates a directory and any required parent directories.
	# Arguments:
	#   $1 - Directory path to create
	# Returns:
	#   0 on success, 1 on failure
	fs_create_dir() {
		local target="$1"
		_fs_is_safe_path "${target}" || return 1

		if [[ -d "${target}" ]]; then
			return 0
		fi

		mkdir -p "${target}" 2>/dev/null || return 1
		return 0
	}

	# Safely removes a file or directory.
	# Includes protections against root/empty path deletions and traversal.
	# Arguments:
	#   $1 - Path to remove
	# Returns:
	#   0 on success, 1 on failure or unsafe input
	fs_remove() {
		local target="$1"
		_fs_is_safe_path "${target}" || return 1

		if [[ ! -e "${target}" ]]; then
			return 0
		fi

		rm -rf "${target}" 2>/dev/null || return 1
		return 0
	}

	# Safely copies a file or directory to a destination.
	# Arguments:
	#   $1 - Source path
	#   $2 - Destination path
	# Returns:
	#   0 on success, 1 on failure
	fs_copy() {
		local source="$1"
		local dest="$2"

		_fs_is_safe_path "${source}" || return 1
		_fs_is_safe_path "${dest}" || return 1
		[[ -e "${source}" ]] || return 1

		cp -R "${source}" "${dest}" 2>/dev/null || return 1
		return 0
	}

	# Safely moves a file or directory to a destination.
	# Arguments:
	#   $1 - Source path
	#   $2 - Destination path
	# Returns:
	#   0 on success, 1 on failure
	fs_move() {
		local source="$1"
		local dest="$2"

		_fs_is_safe_path "${source}" || return 1
		_fs_is_safe_path "${dest}" || return 1
		[[ -e "${source}" ]] || return 1

		mv "${source}" "${dest}" 2>/dev/null || return 1
		return 0
	}

	# Safely makes a file executable.
	# Arguments:
	#   $1 - Path to make executable
	# Returns:
	#   0 on success, 1 on failure
	fs_make_executable() {
		local target="$1"
		_fs_is_safe_path "${target}" || return 1

		[[ -e "${target}" ]] || return 1
		chmod +x "${target}" 2>/dev/null || return 1
		return 0
	}

fi
