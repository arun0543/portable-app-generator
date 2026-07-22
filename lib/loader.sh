#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_LOADER_SH:-}" ]]; then
	readonly _PAG_LIB_LOADER_SH=1

	# ==============================================================================
	# Module: Loader
	# Purpose: Framework dependency loader.
	# Dependencies: None
	# Public API: framework_loaded, framework_require, framework_load
	# Private API: None
	# ==============================================================================

	# Global Framework State Variables
	# _PAG_LOADED_MODULES: Associative array maintaining the loaded module registry
	declare -Ag _PAG_LOADED_MODULES

	# Checks if a framework module is already loaded
	# Arguments:
	#   $1 - Module name (without .sh extension)
	# Returns:
	#   0 if loaded, 1 otherwise
	framework_loaded() {
		local module_name="$1"
		if [[ -n "${_PAG_LOADED_MODULES[${module_name}]:-}" ]]; then
			return 0
		fi
		return 1
	}

	# Requires a framework module, loading it only if not already loaded
	# Arguments:
	#   $1 - Module name
	# Returns:
	#   0 on success, 1 on failure
	framework_require() {
		local module_name="$1"
		framework_loaded "${module_name}" && return 0
		framework_load "${module_name}" || return 1
		return 0
	}

	# Directly loads a framework module and adds it to the registry
	# Verifies successful load by checking for the module's include guard.
	# Arguments:
	#   $1 - Module name
	# Returns:
	#   0 on success, 1 on failure
	framework_load() {
		local module_name="$1"

		if framework_loaded "${module_name}"; then
			return 0
		fi

		local module_path="${PAG_LIB_DIR:-.}/${module_name}.sh"
		if [[ ! -f "${module_path}" ]]; then
			return 1
		fi

		# shellcheck disable=SC1090
		source "${module_path}" || return 1

		# Verify successful load by checking the include guard variable exists
		local upper_name="${module_name^^}"
		local guard_var="_PAG_LIB_${upper_name}_SH"

		if [[ -z "${!guard_var:-}" ]]; then
			return 1
		fi

		_PAG_LOADED_MODULES["${module_name}"]="1"
		return 0
	}

fi
