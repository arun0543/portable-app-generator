#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_PROCESS_SH:-}" ]]; then
readonly _PAG_LIB_PROCESS_SH=1

# ==============================================================================
# Module: Process
# Purpose: Single abstraction around process execution.
# Dependencies: logger
# Public API: process_run, process_capture, process_background, process_wait
# Private API: None
# ==============================================================================

# Executes a command
# Arguments:
#   $@ - Command and arguments to execute
# Returns:
#   Exit status of the command
process_run() {
	log_debug "Process started: $*"
	"$@"
	local status=$?
	log_debug "Process completed: $* (Exit code: ${status})"
	return "${status}"
}

# Executes a command and captures its stdout and stderr
# Arguments:
#   $@ - Command and arguments to execute
# Returns:
#   Exit status of the command
process_capture() {
	log_debug "Process capture started: $*"
	"$@" 2>&1
	local status=$?
	log_debug "Process capture completed: $* (Exit code: ${status})"
	return "${status}"
}

# Executes a command in the background and prints its PID
# Arguments:
#   $@ - Command and arguments to execute
# Returns:
#   0 on success
process_background() {
	log_debug "Process background started: $*"
	"$@" &
	local pid=$!
	log_debug "Process background completed: PID ${pid}"
	printf '%s\n' "${pid}"
	return 0
}

# Waits for a background process to complete
# Arguments:
#   $1 - Process ID (PID) to wait for
# Returns:
#   Exit status of the waited process
process_wait() {
	local pid="$1"
	log_debug "Waiting for PID: ${pid}"
	wait "${pid}"
	local status=$?
	log_debug "Wait completed for PID: ${pid} (Exit code: ${status})"
	return "${status}"
}

fi
