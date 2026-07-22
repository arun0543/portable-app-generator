#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Script: run.sh
# Purpose: Main entry point for the test runner.
# ==============================================================================

PAG_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly PAG_ROOT_DIR

export PAG_LIB_DIR="${PAG_ROOT_DIR}/lib"

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
	local summary_status
	summary_status=$?

	if [[ "${test_status}" -ne 0 || "${summary_status}" -ne 0 ]]; then
		exit 1
	fi
	
	exit 0
}

main "$@"
