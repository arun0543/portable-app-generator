#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_LAUNCHER_SH:-}" ]]; then
	readonly _PAG_LIB_LAUNCHER_SH=1

	framework_require template
	framework_require filesystem
	framework_require logger
	framework_require validator

	# ==============================================================================
	# Module: Launcher
	# Purpose: Launcher generation.
	# Dependencies: template, filesystem, logger
	# Public API: launcher_generate, launcher_remove, launcher_verify
	# Private API: None
	# ==============================================================================

	# Generates an executable launcher script from a template
	# Arguments:
	#   $1 - Template path
	#   $2 - Output launcher path
	#   $@ - Template replacement variables
	# Returns:
	#   0 on success, 1 on failure
	launcher_generate() {
		local template_path="$1"
		local output_path="$2"
		shift 2

		validate_required "${template_path}" || return 1
		validate_required "${output_path}" || return 1

		log_debug "Generating launcher at ${output_path}"

		# Future extension point: Cross-platform support (Windows, macOS, AppImage)
		template_write "${template_path}" "${output_path}" "$@" || return 1

		# Make the generated launcher executable
		fs_make_executable "${output_path}" || return 1

		return 0
	}

	# Removes a generated launcher
	# Arguments:
	#   $1 - Output launcher path
	# Returns:
	#   0 on success, 1 on failure
	launcher_remove() {
		local output_path="$1"
		validate_required "${output_path}" || return 1

		if fs_exists "${output_path}"; then
			log_debug "Removing launcher ${output_path}"
			fs_remove "${output_path}" || return 1
		fi

		return 0
	}

	# Verifies a launcher exists and is executable
	# Arguments:
	#   $1 - Output launcher path
	# Returns:
	#   0 on success, 1 on failure
	launcher_verify() {
		local output_path="$1"
		validate_required "${output_path}" || return 1

		fs_exists "${output_path}" || return 1

		if [[ ! -x "${output_path}" ]]; then
			log_error "Launcher is not executable: ${output_path}"
			return 1
		fi

		return 0
	}

fi
