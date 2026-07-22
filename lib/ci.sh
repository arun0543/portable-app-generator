#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CI_SH:-}" ]]; then
readonly _PAG_LIB_CI_SH=1

framework_require logger
framework_require process

# ==============================================================================
# Module: CI
# Purpose: Continuous integration helper routines.
# Dependencies: logger, process
# Public API: ci_shellcheck, ci_shfmt, ci_tests, ci_all
# Private API: None
# ==============================================================================

# Executes ShellCheck on all framework bash files
# Arguments: None
# Returns: 0 on success, 1 on failure
ci_shellcheck() {
	log_debug "Running ShellCheck"
	
	if command -v shellcheck >/dev/null 2>&1; then
		# Future extension point: Dynamic target discovery
		process_run shellcheck -x lib/*.sh tests/*.sh || return 1
	else
		log_error "shellcheck is not installed"
		return 1
	fi
	
	return 0
}

# Executes shfmt to enforce code style formatting
# Arguments: None
# Returns: 0 on success, 1 on failure
ci_shfmt() {
	log_debug "Running shfmt"
	
	if command -v shfmt >/dev/null 2>&1; then
		process_run shfmt -d lib/ tests/ || return 1
	else
		log_error "shfmt is not installed"
		return 1
	fi
	
	return 0
}

# Executes the test runner natively
# Arguments: None
# Returns: 0 on success, 1 on failure
ci_tests() {
	log_debug "Running Test Suites"
	
	if [[ -x "tests/run.sh" ]]; then
		process_run tests/run.sh || return 1
	else
		log_error "Test runner not found or not executable: tests/run.sh"
		return 1
	fi
	
	return 0
}

# Runs the complete CI pipeline execution sequence
# Arguments: None
# Returns: 0 on success, 1 on failure
ci_all() {
	local failed=0
	
	ci_shellcheck || failed=1
	ci_shfmt || failed=1
	ci_tests || failed=1
	
	if [[ "${failed}" -eq 1 ]]; then
		log_error "CI pipeline failed"
		return 1
	fi
	
	log_debug "CI pipeline succeeded"
	return 0
}

fi
