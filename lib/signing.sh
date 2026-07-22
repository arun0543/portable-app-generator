#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_SIGNING_SH:-}" ]]; then
	readonly _PAG_LIB_SIGNING_SH=1

	framework_require logger
	framework_require process

	# ==============================================================================
	# Module: Signing
	# Purpose: Artifact signing and signature verification.
	# Dependencies: logger, process
	# Public API: signing_sign, signing_verify, signing_detect_provider
	# Private API: None
	# ==============================================================================

	# Detects the active or preferred signing provider
	# Arguments:
	#   $1 - Requested provider (optional, defaults to gpg)
	# Returns: 0 and prints provider on success, 1 on failure
	signing_detect_provider() {
		local provider="${1:-gpg}"
		case "${provider}" in
		gpg)
			if command -v gpg >/dev/null 2>&1; then
				printf '%s\n' "${provider}"
				return 0
			fi
			log_error "GPG provider requested but gpg is not installed"
			return 1
			;;
		# Future extension points: cosign, minisign, sigstore
		*)
			log_error "Unsupported signing provider: ${provider}"
			return 1
			;;
		esac
	}

	# Signs an artifact
	# Arguments:
	#   $1 - Target file
	#   $2 - Output signature file
	#   $3 - Provider (defaults to gpg)
	# Returns: 0 on success, 1 on failure
	signing_sign() {
		local target="$1"
		local output="$2"
		local provider="${3:-gpg}"

		if [[ ! -f "${target}" ]]; then
			log_error "Signing target not found: ${target}"
			return 1
		fi

		if ! provider="$(signing_detect_provider "${provider}")"; then
			return 1
		fi

		log_debug "Signing ${target} using ${provider}"

		case "${provider}" in
		gpg)
			process_run gpg --detach-sign --armor --output "${output}" "${target}" || return 1
			;;
		esac

		return 0
	}

	# Verifies a signature against an artifact
	# Arguments:
	#   $1 - Target file
	#   $2 - Signature file
	#   $3 - Provider (defaults to gpg)
	# Returns: 0 on success, 1 on failure
	signing_verify() {
		local target="$1"
		local sig_file="$2"
		local provider="${3:-gpg}"

		if [[ ! -f "${target}" ]]; then
			log_error "Verification target not found: ${target}"
			return 1
		fi

		if [[ ! -f "${sig_file}" ]]; then
			log_error "Signature file not found: ${sig_file}"
			return 1
		fi

		if ! provider="$(signing_detect_provider "${provider}")"; then
			return 1
		fi

		log_debug "Verifying ${target} with signature ${sig_file} using ${provider}"

		case "${provider}" in
		gpg)
			process_run gpg --verify "${sig_file}" "${target}" || return 1
			;;
		esac

		return 0
	}

fi
