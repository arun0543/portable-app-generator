#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_REGISTRY_CLI_SH:-}" ]]; then
	readonly _PAG_LIB_REGISTRY_CLI_SH=1

	# ==============================================================================
	# Module: Registry CLI
	# Purpose: Command registry for CLI dispatch, completion, and help.
	# Dependencies: None
	# Public API: cli_register_command, cli_get_registered_commands, cli_is_command_registered
	# Private API: None
	# ==============================================================================

	declare -ag _PAG_CLI_REGISTERED_COMMANDS=()

	# Registers a command
	# Arguments:
	#   $1 - Command name
	# Returns: 0
	cli_register_command() {
		local cmd="$1"
		_PAG_CLI_REGISTERED_COMMANDS+=("${cmd}")
		return 0
	}

	# Retrieves all registered commands
	# Arguments: None
	# Returns: 0 and prints commands separated by newlines
	cli_get_registered_commands() {
		if [[ ${#_PAG_CLI_REGISTERED_COMMANDS[@]} -gt 0 ]]; then
			printf '%s\n' "${_PAG_CLI_REGISTERED_COMMANDS[@]}"
		fi
		return 0
	}

	# Checks if a command is registered
	# Arguments:
	#   $1 - Command to check
	# Returns: 0 if registered, 1 otherwise
	cli_is_command_registered() {
		local target="$1"
		local cmd
		for cmd in "${_PAG_CLI_REGISTERED_COMMANDS[@]:-}"; do
			if [[ "${cmd}" == "${target}" ]]; then
				return 0
			fi
		done
		return 1
	}

	# Register default core commands
	cli_register_command "init"
	cli_register_command "new"
	cli_register_command "build"
	cli_register_command "validate"
	cli_register_command "export"
	cli_register_command "install"
	cli_register_command "remove"
	cli_register_command "list"
	cli_register_command "info"
	cli_register_command "doctor"
	cli_register_command "version"
	cli_register_command "help"
	cli_register_command "docs"
	cli_register_command "plugin"
	cli_register_command "template"
	cli_register_command "sdk"

fi
