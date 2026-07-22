#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_EXECUTOR_SH:-}" ]]; then
	readonly _PAG_LIB_EXECUTOR_SH=1

	framework_require loader
	framework_require lock
	framework_require hooks
	framework_require context
	framework_require manifest
	framework_require compatibility
	framework_require process
	framework_require logger
	framework_require error
	framework_require plugin

	# ==============================================================================
	# Module: Executor
	# Purpose: Official plugin execution engine.
	# Dependencies: loader, lock, hooks, context, manifest, compatibility, process, logger, error, plugin
	# Public API: plugin_execute
	# Private API: None
	# ==============================================================================

	# Safely executes a plugin hook providing isolation and lifecycle guarantees
	# Arguments:
	#   $1 - Plugin name
	#   $2 - Instance directory path
	#   $3 - Hook name
	# Returns:
	#   0 on success, >0 on failure
	plugin_execute() {
		local plugin_name="$1"
		local instance_dir="$2"
		local hook_name="$3"

		validate_required "${plugin_name}" || return 1
		validate_required "${instance_dir}" || return 1
		validate_required "${hook_name}" || return 1

		local plugin_dir="${PAG_PLUGIN_DIR:-.}/${plugin_name}"
		local lock_file="${PAG_RUNTIME_DIR:-/tmp/pag_runtime}/${plugin_name}.lock"
		local status=0

		log_debug "Executor starting for plugin ${plugin_name}, hook ${hook_name}"

		_executor_prepare() {
			lock_acquire "${lock_file}" || return 1
			plugin_load "${plugin_name}" || return 1
			manifest_load "${plugin_dir}/plugin.conf" || return 1
			compatibility_check "${plugin_dir}/plugin.conf" || return 1
			context_create "${plugin_dir}" "${instance_dir}" || return 1
			context_export || return 1
			return 0
		}

		_executor_run() {
			local run_status=0
			hook_execute "${plugin_dir}" "${hook_name}" || run_status=$?
			if [[ "${run_status}" -ne 0 ]]; then
				error_set "Hook ${hook_name} failed with exit code ${run_status}"
				log_error "$(error_last)"
			fi
			return "${run_status}"
		}

		# shellcheck disable=SC2317
		_executor_cleanup() {
			context_destroy || log_warn "Failed to destroy context for ${plugin_name}"
			lock_release "${lock_file}" || log_warn "Failed to release lock for ${plugin_name}"
		}

		# Ensure cleanup is always called on exit from this function
		trap '_executor_cleanup' RETURN

		if ! _executor_prepare; then
			error_set "Preparation failed for ${plugin_name}"
			log_error "$(error_last)"
			return 1
		fi

		_executor_run || status=$?

		return "${status}"
	}

fi
