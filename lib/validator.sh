#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_VALIDATOR_SH:-}" ]]; then
	readonly _PAG_LIB_VALIDATOR_SH=1

	# ==============================================================================
	# Module: Validator
	# Purpose: Provides generic, reusable validation helpers.
	# Dependencies: command
	# Public API: validate_required, validate_directory, validate_file, validate_command
	# Private API: None
	# ==============================================================================

	# Validates that a required value is provided and not empty.
	# Arguments:
	#   $1 - Value to check
	# Returns:
	#   0 if value is present, 1 otherwise
	validate_required() {
		local value="$1"
		[[ -n "${value}" ]] || return 1
		return 0
	}

	# Validates that a target is a directory and is readable.
	# Arguments:
	#   $1 - Directory path to validate
	# Returns:
	#   0 if valid, 1 otherwise
	validate_directory() {
		local target="$1"
		[[ -n "${target}" ]] || return 1
		[[ -d "${target}" ]] || return 1
		[[ -r "${target}" ]] || return 1
		return 0
	}

	# Validates that a target is a regular file and is readable.
	# Arguments:
	#   $1 - File path to validate
	# Returns:
	#   0 if valid, 1 otherwise
	validate_file() {
		local target="$1"
		[[ -n "${target}" ]] || return 1
		[[ -f "${target}" ]] || return 1
		[[ -r "${target}" ]] || return 1
		return 0
	}

	# Validates that a command exists and is executable in the system path.
	# Arguments:
	#   $1 - Command name to validate
	# Returns:
	#   0 if command is available, 1 otherwise
	validate_command() {
		local cmd="$1"
		[[ -n "${cmd}" ]] || return 1
		command -v "${cmd}" >/dev/null 2>&1 || return 1
		return 0
	}

fi
