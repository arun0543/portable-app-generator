#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_REGISTRY_SH:-}" ]]; then
	readonly _PAG_LIB_REGISTRY_SH=1

	framework_require config
	framework_require filesystem
	framework_require logger

	# ==============================================================================
	# Module: Registry
	# Purpose: Manage installed plugin registry.
	# Dependencies: config, filesystem, logger
	# Public API: registry_exists, registry_register, registry_unregister, registry_list
	# Private API: None
	# ==============================================================================

	readonly PAG_REGISTRY_FILE="${PAG_RUNTIME_DIR:-/tmp/pag_runtime}/registry.conf"

	# Checks if the registry file exists
	# Arguments:
	#   None
	# Returns:
	#   0 on success, 1 on failure
	registry_exists() {
		fs_exists "${PAG_REGISTRY_FILE}" || return 1
		return 0
	}

	# Registers a plugin in the registry
	# Arguments:
	#   $1 - Plugin name
	#   $2 - Plugin version
	# Returns:
	#   0 on success, 1 on failure
	registry_register() {
		local plugin_name="$1"
		local plugin_version="$2"
		validate_required "${plugin_name}" || return 1
		validate_required "${plugin_version}" || return 1

		if ! registry_exists; then
			fs_create_dir "$(dirname "${PAG_REGISTRY_FILE}")" || return 1
			printf '' >"${PAG_REGISTRY_FILE}" || return 1
		fi

		local tmp_registry
		tmp_registry="$(mktemp)" || return 1
		cp -p "${PAG_REGISTRY_FILE}" "${tmp_registry}" || return 1

		config_write "${tmp_registry}" "${plugin_name}" "${plugin_version}" || return 1
		mv -f "${tmp_registry}" "${PAG_REGISTRY_FILE}" || return 1

		log_debug "Registered plugin ${plugin_name}@${plugin_version}"
		return 0
	}

	# Unregisters a plugin from the registry
	# Arguments:
	#   $1 - Plugin name
	# Returns:
	#   0 on success, 1 on failure
	registry_unregister() {
		local plugin_name="$1"
		validate_required "${plugin_name}" || return 1

		registry_exists || return 0

		config_remove "${PAG_REGISTRY_FILE}" "${plugin_name}" || return 1
		log_debug "Unregistered plugin ${plugin_name}"
		return 0
	}

	# Lists all installed plugins
	# Arguments:
	#   None
	# Returns:
	#   0 on success, 1 on failure
	registry_list() {
		registry_exists || return 0

		local line key
		while IFS= read -r line || [[ -n "${line}" ]]; do
			[[ -z "${line}" || "${line}" == "#"* ]] && continue
			key="${line%%=*}"
			printf '%s\n' "${key}"
		done <"${PAG_REGISTRY_FILE}"

		return 0
	}

fi
