#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_ENVIRONMENT_SH:-}" ]]; then
	readonly _PAG_LIB_ENVIRONMENT_SH=1

	# ==============================================================================
	# Module: Environment
	# Purpose: Environment variable management from .env style files.
	# Dependencies: config, validator
	# Public API: env_exists, env_read, env_write, env_export
	# Private API: None
	# ==============================================================================

	# Checks if an environment variable exists in a file
	# Arguments:
	#   $1 - Path to environment file
	#   $2 - Variable key
	# Returns:
	#   0 if it exists, 1 otherwise
	env_exists() {
		config_exists "$@"
	}

	# Reads an environment variable from a file
	# Arguments:
	#   $1 - Path to environment file
	#   $2 - Variable key
	# Returns:
	#   0 on success, 1 on failure
	env_read() {
		config_read "$@"
	}

	# Writes an environment variable to a file
	# Arguments:
	#   $1 - Path to environment file
	#   $2 - Variable key
	#   $3 - Variable value
	#   $4 - (Optional) Set to "true" to overwrite
	# Returns:
	#   0 on success, 1 on failure
	env_write() {
		config_write "$@"
	}

	# Loads and exports all variables from an environment file safely
	# Rejects any key that is not a valid bash identifier.
	# Arguments:
	#   $1 - Path to environment file
	# Returns:
	#   0 on success, 1 on failure
	env_export() {
		local env_file="$1"
		validate_required "${env_file}" || return 1
		validate_file "${env_file}" || return 1

		local line key val
		while IFS= read -r line || [[ -n "${line}" ]]; do
			[[ -z "${line}" || "${line}" == "#"* ]] && continue

			key="${line%%=*}"
			val="${line#*=}"

			# Validate identifier (must start with letter/underscore, contain only alphanum/underscore)
			if [[ ! "${key}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
				return 1
			fi

			export "${key}=${val}"
		done <"${env_file}"

		return 0
	}

fi
