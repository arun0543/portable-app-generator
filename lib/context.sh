#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CONTEXT_SH:-}" ]]; then
	readonly _PAG_LIB_CONTEXT_SH=1

	framework_require environment
	framework_require metadata
	framework_require logger
	framework_require filesystem

	# ==============================================================================
	# Module: Context
	# Purpose: Create plugin execution context.
	# Dependencies: environment, metadata, logger, filesystem
	# Public API: context_create, context_destroy, context_export
	# Private API: _context_file
	# ==============================================================================

	# Internal variable pointing to the context file
	_PAG_CURRENT_CONTEXT_FILE=""

	# Retrieves the current context file path
	# Arguments: None
	# Returns: Path string
	_context_file() {
		printf '%s\n' "${_PAG_CURRENT_CONTEXT_FILE:-${PAG_RUNTIME_DIR:-/tmp/pag_runtime}/plugin_context.env}"
	}

	# Creates a context environment file containing framework paths
	# Arguments:
	#   $1 - Plugin directory path
	#   $2 - Instance directory path
	# Returns:
	#   0 on success, 1 on failure
	context_create() {
		local plugin_dir="$1"
		local instance_dir="$2"

		validate_required "${plugin_dir}" || return 1
		validate_required "${instance_dir}" || return 1

		local context_file
		context_file="$(_context_file)"

		fs_create_dir "$(dirname "${context_file}")" || return 1
		printf '' >"${context_file}" || return 1

		local template_path="${plugin_dir}/templates"
		local meta_path="${instance_dir}/${PAG_METADATA_FILE:-metadata.conf}"
		local env_path="${instance_dir}/.env"
		local runtime_path="${PAG_RUNTIME_DIR:-/tmp/pag_runtime}"

		# Populate context variables
		env_write "${context_file}" "PAG_CTX_PLUGIN_PATH" "${plugin_dir}" || return 1
		env_write "${context_file}" "PAG_CTX_INSTANCE_PATH" "${instance_dir}" || return 1
		env_write "${context_file}" "PAG_CTX_RUNTIME_PATH" "${runtime_path}" || return 1
		env_write "${context_file}" "PAG_CTX_TEMPLATE_PATH" "${template_path}" || return 1
		env_write "${context_file}" "PAG_CTX_METADATA_PATH" "${meta_path}" || return 1
		env_write "${context_file}" "PAG_CTX_ENVIRONMENT_PATH" "${env_path}" || return 1

		_PAG_CURRENT_CONTEXT_FILE="${context_file}"
		log_debug "Context created at ${context_file}"
		return 0
	}

	# Exports context variables to the environment
	# Arguments: None
	# Returns: 0 on success, 1 on failure
	context_export() {
		local context_file
		context_file="$(_context_file)"
		fs_exists "${context_file}" || return 1

		env_export "${context_file}" || return 1
		log_debug "Context exported to environment"
		return 0
	}

	# Destroys the plugin context safely
	# Arguments: None
	# Returns: 0 on success, 1 on failure
	context_destroy() {
		local context_file
		context_file="$(_context_file)"

		if fs_exists "${context_file}"; then
			fs_remove "${context_file}" || return 1
			log_debug "Context destroyed: ${context_file}"
		fi

		_PAG_CURRENT_CONTEXT_FILE=""
		return 0
	}

fi
