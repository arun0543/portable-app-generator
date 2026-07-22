#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Script: run.sh
# Purpose: Main entry point for the test runner.
# ==============================================================================

readonly PAG_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load the framework
# shellcheck disable=SC1091
source "${PAG_ROOT_DIR}/lib/loader.sh" || {
	printf 'Failed to load framework loader.\n' >&2
	exit 1
}

framework_require test
framework_require assert
framework_require mock
framework_require coverage
framework_require logger

# Internal test discovery logic
_discover_tests() {
	local test_dir="${PAG_ROOT_DIR}/tests"
	local test_file
	
	# Future extension point: Support granular test suites
	if [[ -d "${test_dir}/unit" ]]; then
		for test_file in "${test_dir}"/unit/*.sh; do
			if [[ -f "${test_file}" ]]; then
				# shellcheck disable=SC1090
				source "${test_file}"
			fi
		done
	fi
	
	if [[ -d "${test_dir}/integration" ]]; then
		for test_file in "${test_dir}"/integration/*.sh; do
			if [[ -f "${test_file}" ]]; then
				# shellcheck disable=SC1090
				source "${test_file}"
			fi
		done
	fi
}

main() {
	coverage_begin
	
	_discover_tests
	
	test_run
	local test_status=$?
	
	coverage_end
	coverage_report
	
	test_summary
	local summary_status=$?
	
	if [[ "${test_status}" -ne 0 || "${summary_status}" -ne 0 ]]; then
		return 1 2>/dev/null || exit 1
	fi
	
	return 0 2>/dev/null || exit 0
}

main "$@"
