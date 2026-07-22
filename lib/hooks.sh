#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_HOOKS_SH:-}" ]]; then
	readonly _PAG_LIB_HOOKS_SH=1

	framework_require process
	framework_require logger
	framework_require validator
	framework_require filesystem

	# ==============================================================================
	# Module: Hooks
	# Purpose: Plugin lifecycle management.
	# Dependencies: process, logger, validator, filesystem
	# Public API: hook_exists, hook_execute
	# Private API: None
	# ==============================================================================

	# Checks if a specific hook exists for a plugin
	# Arguments:
	#   $1 - Plugin directory path
	#   $2 - Hook name
	# Returns:
	#   0 if exists, 1 otherwise
	hook_exists() {
		local plugin_dir="$1"
		local hook_name="$2"
		validate_required "${plugin_dir}" || return 1
		validate_required "${hook_name}" || return 1

		local hook_script="${plugin_dir}/hooks/${hook_name}.sh"
		fs_exists "${hook_script}" || return 1

		return 0
	}

	# Executes a specific plugin hook if it exists
	# Arguments:
	#   $1 - Plugin directory path
	#   $2 - Hook name
	#   $@ - Additional arguments to pass to the hook
	# Returns:
	#   Exit code of the hook on success, 1 on critical failure
	hook_execute() {
		local plugin_dir="$1"
		local hook_name="$2"
		shift 2

		validate_required "${plugin_dir}" || return 1
		validate_required "${hook_name}" || return 1

		if ! hook_exists "${plugin_dir}" "${hook_name}"; then
			log_debug "Hook ${hook_name} not found in ${plugin_dir}, skipping."
			return 0
		fi

		local hook_script="${plugin_dir}/hooks/${hook_name}.sh"
		log_debug "Executing hook: ${hook_name} in ${plugin_dir}"

		# Execute via process abstraction
		process_run "${hook_script}" "$@"
		local status=$?

		return "${status}"
	}

fi
