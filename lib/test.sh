#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_TEST_SH:-}" ]]; then
readonly _PAG_LIB_TEST_SH=1

framework_require logger

# ==============================================================================
# Module: Test
# Purpose: Test runner and registry.
# Dependencies: logger
# Public API: test_register, test_run, test_summary
# Private API: None
# ==============================================================================

declare -a _PAG_TEST_REGISTRY=()
_PAG_TEST_PASSED=0
_PAG_TEST_FAILED=0
_PAG_TEST_SKIPPED=0
_PAG_TEST_START_TIME=0

# Registers a test function
# Arguments:
#   $1 - Name of the test function
# Returns: 0
test_register() {
	local test_func="$1"
	local existing
	for existing in "${_PAG_TEST_REGISTRY[@]:-}"; do
		if [[ "${existing}" == "${test_func}" ]]; then
			log_debug "Test already registered: ${test_func}"
			return 0
		fi
	done
	
	_PAG_TEST_REGISTRY+=("${test_func}")
	return 0
}

# Runs all registered tests
# Arguments: None
# Returns: 0
test_run() {
	_PAG_TEST_PASSED=0
	_PAG_TEST_FAILED=0
	_PAG_TEST_SKIPPED=0
	_PAG_TEST_START_TIME="$(date +%s)"
	
	local test_func
	for test_func in "${_PAG_TEST_REGISTRY[@]:-}"; do
		if ! declare -f "${test_func}" >/dev/null; then
			log_error "Test function not found: ${test_func}"
			_PAG_TEST_SKIPPED=$((_PAG_TEST_SKIPPED + 1))
			continue
		fi
		
		log_debug "Running test: ${test_func}"
		
		# Future extension point: Setup/Teardown, parallel execution, timeouts
		if "${test_func}"; then
			_PAG_TEST_PASSED=$((_PAG_TEST_PASSED + 1))
		else
			_PAG_TEST_FAILED=$((_PAG_TEST_FAILED + 1))
		fi
	done
	
	return 0
}

# Outputs a summary of test results
# Arguments: None
# Returns: 0 if all tests passed, 1 otherwise
test_summary() {
	local end_time
	end_time="$(date +%s)"
	local duration=$((end_time - _PAG_TEST_START_TIME))
	local total=$((${_PAG_TEST_PASSED} + ${_PAG_TEST_FAILED} + ${_PAG_TEST_SKIPPED}))
	
	printf '========================================\n'
	printf 'Test Summary\n'
	printf '========================================\n'
	printf 'Total:   %d\n' "${total}"
	printf 'Passed:  %d\n' "${_PAG_TEST_PASSED}"
	printf 'Failed:  %d\n' "${_PAG_TEST_FAILED}"
	printf 'Skipped: %d\n' "${_PAG_TEST_SKIPPED}"
	printf 'Time:    %ds\n' "${duration}"
	printf '========================================\n'
	
	# Future extension point: JUnit XML export
	
	if [[ ${_PAG_TEST_FAILED} -gt 0 ]]; then
		return 1
	fi
	return 0
}

fi
