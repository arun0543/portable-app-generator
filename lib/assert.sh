#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_ASSERT_SH:-}" ]]; then
	readonly _PAG_LIB_ASSERT_SH=1

	framework_require logger

	# ==============================================================================
	# Module: Assert
	# Purpose: Assertion library for unit and integration testing.
	# Dependencies: logger
	# Public API: assert_true, assert_false, assert_equals, assert_not_equals,
	#             assert_file_exists, assert_directory_exists, assert_contains,
	#             assert_empty, assert_success, assert_failure
	# Private API: _assert_fail
	# ==============================================================================

	# Internal helper to handle assertion failures
	# Arguments:
	#   $1 - Failure message
	# Returns: 1
	_assert_fail() {
		local message="$1"
		log_error "Assertion Failed: ${message}"
		return 1
	}

	# Asserts that a value is truthy ("true" or "0" typically in bash)
	# Arguments:
	#   $1 - Actual value
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_true() {
		local value="$1"
		local msg="${2:-Expected true or 0, got ${value}}"

		if [[ "${value}" != "true" && "${value}" != "0" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a value is falsy (anything other than "true" or "0")
	# Arguments:
	#   $1 - Actual value
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_false() {
		local value="$1"
		local msg="${2:-Expected false, got ${value}}"

		if [[ "${value}" == "true" || "${value}" == "0" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that two values are equal
	# Arguments:
	#   $1 - Expected value
	#   $2 - Actual value
	#   $3 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_equals() {
		local expected="$1"
		local actual="$2"
		local msg="${3:-Expected \"${expected}\", got \"${actual}\"}"

		if [[ "${expected}" != "${actual}" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that two values are not equal
	# Arguments:
	#   $1 - Expected value
	#   $2 - Actual value
	#   $3 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_not_equals() {
		local expected="$1"
		local actual="$2"
		local msg="${3:-Expected not to equal \"${expected}\", got \"${actual}\"}"

		if [[ "${expected}" == "${actual}" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a file exists
	# Arguments:
	#   $1 - Target file path
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_file_exists() {
		local target="$1"
		local msg="${2:-Expected file to exist: ${target}}"

		if [[ ! -f "${target}" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a directory exists
	# Arguments:
	#   $1 - Target directory path
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_directory_exists() {
		local target="$1"
		local msg="${2:-Expected directory to exist: ${target}}"

		if [[ ! -d "${target}" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a string contains a substring
	# Arguments:
	#   $1 - Haystack string
	#   $2 - Needle string
	#   $3 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_contains() {
		local haystack="$1"
		local needle="$2"
		local msg="${3:-Expected to find \"${needle}\" in \"${haystack}\"}"

		if [[ "${haystack}" != *"${needle}"* ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a string is empty
	# Arguments:
	#   $1 - Target string
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_empty() {
		local target="$1"
		local msg="${2:-Expected string to be empty, got \"${target}\"}"

		if [[ -n "${target}" ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a command executed successfully (exit status 0)
	# Arguments:
	#   $1 - Exit status code
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_success() {
		local status="$1"
		local msg="${2:-Expected success (0), got status ${status}}"

		if [[ "${status}" -ne 0 ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

	# Asserts that a command failed (exit status non-zero)
	# Arguments:
	#   $1 - Exit status code
	#   $2 - Optional failure message
	# Returns: 0 on success, 1 on failure
	assert_failure() {
		local status="$1"
		local msg="${2:-Expected failure (non-zero), got status ${status}}"

		if [[ "${status}" -eq 0 ]]; then
			_assert_fail "${msg}"
			return 1
		fi
		return 0
	}

fi
