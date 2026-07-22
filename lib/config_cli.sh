#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CONFIG_CLI_SH:-}" ]]; then
	readonly _PAG_LIB_CONFIG_CLI_SH=1

	framework_require config
	framework_require filesystem
	framework_require validator

	# ==============================================================================
	# Module: Config CLI
	# Purpose: CLI configuration state management.
	# Dependencies: config, filesystem, validator
	# Public API: config_cli_get, config_cli_set, config_cli_init
	# Private API: None
	# ==============================================================================

	readonly PAG_CLI_CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME:-/tmp}/.config}/pag"
	readonly PAG_CLI_CONFIG_FILE="${PAG_CLI_CONFIG_DIR}/config.conf"

	# Initializes the CLI configuration environment
	# Arguments: None
	# Returns: 0 on success, 1 on failure
	config_cli_init() {
		if ! fs_exists "${PAG_CLI_CONFIG_DIR}"; then
			fs_create_dir "${PAG_CLI_CONFIG_DIR}" || return 1
		fi

		if ! fs_exists "${PAG_CLI_CONFIG_FILE}"; then
			printf '# PAG CLI Configuration\n' >"${PAG_CLI_CONFIG_FILE}" 2>/dev/null || return 1
		fi

		return 0
	}

	# Retrieves a value from the CLI configuration
	# Arguments:
	#   $1 - Configuration key
	# Returns:
	#   0 and prints value on success, 1 on failure
	config_cli_get() {
		local key="$1"
		validate_required "${key}" || return 1

		config_cli_init || return 1
		config_read "${PAG_CLI_CONFIG_FILE}" "${key}" || return 1
		return 0
	}

	# Sets a value in the CLI configuration
	# Arguments:
	#   $1 - Configuration key
	#   $2 - Configuration value
	# Returns:
	#   0 on success, 1 on failure
	config_cli_set() {
		local key="$1"
		local value="$2"
		validate_required "${key}" || return 1

		config_cli_init || return 1
		config_write "${PAG_CLI_CONFIG_FILE}" "${key}" "${value}" || return 1
		return 0
	}

fi
