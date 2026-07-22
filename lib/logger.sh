#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_LOGGER_SH:-}" ]]; then
readonly _PAG_LIB_LOGGER_SH=1

# ==============================================================================
# Module: Logger
# Purpose: Provides a standard logging framework with timestamps and level filtering.
# Dependencies: date, printf
# Public API: log_trace, log_debug, log_info, log_success, log_warn, log_error, log_fatal
# Private API: _log_dispatch
# ==============================================================================

# Internal helper to format and dispatch log messages.
# Note: Log file write failures are explicitly ignored so that logging
# issues do not halt the main application execution.
# Arguments:
#   $1 - Log level (e.g., INFO, ERROR)
#   $2.. - Message to log
# Returns:
#   0 on success
_log_dispatch() {
	local level="$1"
	shift
	local message="$*"
	local timestamp
	timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	local formatted_message="[${timestamp}] [${level}] ${message}"

	printf '%s\n' "${formatted_message}" >&2

	if [[ -n "${PAG_LOG_FILE:-}" ]]; then
		if [[ -f "${PAG_LOG_FILE}" ]] || [[ -d "$(dirname "${PAG_LOG_FILE}")" ]]; then
			printf '%s\n' "${formatted_message}" >>"${PAG_LOG_FILE}" || true
		fi
	fi
	return 0
}

# Logs a TRACE level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_trace() {
	_log_dispatch "TRACE" "$@"
	return 0
}

# Logs a DEBUG level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_debug() {
	_log_dispatch "DEBUG" "$@"
	return 0
}

# Logs an INFO level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_info() {
	_log_dispatch "INFO" "$@"
	return 0
}

# Logs a SUCCESS level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_success() {
	_log_dispatch "SUCCESS" "$@"
	return 0
}

# Logs a WARN level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_warn() {
	_log_dispatch "WARN" "$@"
	return 0
}

# Logs an ERROR level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_error() {
	_log_dispatch "ERROR" "$@"
	return 0
}

# Logs a FATAL level message
# Arguments:
#   $@ - Message to log
# Returns:
#   0 on success
log_fatal() {
	_log_dispatch "FATAL" "$@"
	return 0
}

fi
