#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_MOCK_SH:-}" ]]; then
readonly _PAG_LIB_MOCK_SH=1

framework_require logger
framework_require filesystem

# ==============================================================================
# Module: Mock
# Purpose: Testing isolation overrides and auto-restoration.
# Dependencies: logger, filesystem
# Public API: mock_filesystem, mock_process, mock_environment, mock_cleanup
# Private API: None
# ==============================================================================

_PAG_MOCK_FS_DIR=""
declare -A _PAG_MOCK_ENV_RESTORE=()

# Initializes a mock filesystem environment
# Arguments: None
# Returns: 0 and prints temporary directory on success, 1 on failure
mock_filesystem() {
	if [[ -n "${_PAG_MOCK_FS_DIR}" ]]; then
		log_error "Mock filesystem already active"
		return 1
	fi
	
	_PAG_MOCK_FS_DIR="$(mktemp -d -t pag-mock-fs-XXXXXX)"
	log_debug "Initialized mock filesystem at ${_PAG_MOCK_FS_DIR}"
	
	printf '%s\n' "${_PAG_MOCK_FS_DIR}"
	return 0
}

# Mocks a system process or executable path
# Arguments:
#   $1 - Process name
#   $2 - Mock behavior (optional)
# Returns: 0
mock_process() {
	local cmd_name="$1"
	local mock_behavior="${2:-}"
	
	log_debug "Mocking process: ${cmd_name}"
	# Future extension point: Shell alias injection or temp path interceptor script
	
	return 0
}

# Mocks an environment variable
# Arguments:
#   $1 - Variable name
#   $2 - Variable value
# Returns: 0
mock_environment() {
	local var_name="$1"
	local mock_value="$2"
	
	if [[ -n "${!var_name+x}" ]]; then
		_PAG_MOCK_ENV_RESTORE["${var_name}"]="${!var_name}"
	else
		_PAG_MOCK_ENV_RESTORE["${var_name}"]=""
	fi
	
	export "${var_name}=${mock_value}"
	log_debug "Mocked environment ${var_name}=${mock_value}"
	
	return 0
}

# Cleans up and restores all mock environments
# Arguments: None
# Returns: 0
mock_cleanup() {
	log_debug "Cleaning up mocks"
	
	if [[ -n "${_PAG_MOCK_FS_DIR}" ]]; then
		fs_remove "${_PAG_MOCK_FS_DIR}" || true
		_PAG_MOCK_FS_DIR=""
	fi
	
	local var_name
	for var_name in "${!_PAG_MOCK_ENV_RESTORE[@]}"; do
		local orig_val="${_PAG_MOCK_ENV_RESTORE[${var_name}]}"
		if [[ -z "${orig_val}" ]]; then
			unset "${var_name}"
		else
			export "${var_name}=${orig_val}"
		fi
	done
	_PAG_MOCK_ENV_RESTORE=()
	
	# Future extension point: Remove process aliases/interceptors
	
	return 0
}

fi
