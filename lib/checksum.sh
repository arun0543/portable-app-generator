#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CHECKSUM_SH:-}" ]]; then
	readonly _PAG_LIB_CHECKSUM_SH=1

	framework_require logger
	framework_require process

	# ==============================================================================
	# Module: Checksum
	# Purpose: Checksum generation and verification for artifacts.
	# Dependencies: logger, process
	# Public API: checksum_generate, checksum_verify, checksum_algorithm
	# Private API: None
	# ==============================================================================

	# Determines the active or requested checksum algorithm
	# Arguments:
	#   $1 - Requested algorithm (optional, defaults to sha256)
	# Returns: 0 and prints algorithm on success, 1 on failure
	checksum_algorithm() {
		local algo="${1:-sha256}"
		case "${algo}" in
		sha256 | sha512)
			printf '%s\n' "${algo}"
			return 0
			;;
		# Future extension point: blake3
		*)
			log_error "Unsupported checksum algorithm: ${algo}"
			return 1
			;;
		esac
	}

	# Internal helper to map algorithm to command
	_checksum_command() {
		local algo="$1"
		case "${algo}" in
		sha256) printf 'sha256sum\n' ;;
		sha512) printf 'sha512sum\n' ;;
		*) return 1 ;;
		esac
		return 0
	}

	# Generates a checksum for a given file
	# Arguments:
	#   $1 - Target file
	#   $2 - Algorithm (sha256, sha512)
	#   $3 - Output file
	# Returns: 0 on success, 1 on failure
	checksum_generate() {
		local target="$1"
		local algo="$2"
		local output="$3"

		if [[ ! -f "${target}" ]]; then
			log_error "Checksum target not found: ${target}"
			return 1
		fi

		if ! algo="$(checksum_algorithm "${algo}")"; then
			return 1
		fi

		log_debug "Generating ${algo} checksum for ${target}"

		local cmd
		if ! cmd="$(_checksum_command "${algo}")"; then
			log_error "Command not found for algorithm: ${algo}"
			return 1
		fi

		process_run "${cmd}" "${target}" >"${output}" || return 1

		return 0
	}

	# Verifies a checksum file
	# Arguments:
	#   $1 - Checksum file
	#   $2 - Algorithm (sha256, sha512)
	# Returns: 0 on success, 1 on failure
	checksum_verify() {
		local checksum_file="$1"
		local algo="$2"

		if [[ ! -f "${checksum_file}" ]]; then
			log_error "Checksum file not found: ${checksum_file}"
			return 1
		fi

		if ! algo="$(checksum_algorithm "${algo}")"; then
			return 1
		fi

		log_debug "Verifying ${algo} checksum using ${checksum_file}"

		local cmd
		if ! cmd="$(_checksum_command "${algo}")"; then
			log_error "Command not found for algorithm: ${algo}"
			return 1
		fi

		process_run "${cmd}" -c "${checksum_file}" || return 1

		return 0
	}

fi
