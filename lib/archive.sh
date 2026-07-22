#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_ARCHIVE_SH:-}" ]]; then
	readonly _PAG_LIB_ARCHIVE_SH=1

	framework_require process
	framework_require filesystem
	framework_require validator
	framework_require logger

	# ==============================================================================
	# Module: Archive
	# Purpose: Portable archive generation.
	# Dependencies: process, filesystem, validator, logger
	# Public API: archive_create, archive_extract, archive_verify
	# Private API: archive_detect_format
	# ==============================================================================

	# Internal helper to detect archive format
	# Arguments:
	#   $1 - Archive path
	# Returns:
	#   Format string on stdout
	archive_detect_format() {
		local target="$1"

		if [[ "${target}" == *".tar.gz" || "${target}" == *".tgz" ]]; then
			printf '%s\n' "tar.gz"
		elif [[ "${target}" == *".zip" ]]; then
			printf '%s\n' "zip"
		elif [[ "${target}" == *".AppImage" ]]; then
			printf '%s\n' "appimage"
		else
			printf '%s\n' "unknown"
		fi
		return 0
	}

	# Creates an archive from a source directory
	# Arguments:
	#   $1 - Source directory path
	#   $2 - Output archive path
	# Returns:
	#   0 on success, 1 on failure
	archive_create() {
		local source_dir="$1"
		local archive_path="$2"

		validate_required "${source_dir}" || return 1
		validate_required "${archive_path}" || return 1
		fs_is_dir "${source_dir}" || return 1

		log_debug "Creating archive ${archive_path} from ${source_dir}"

		local format
		format="$(archive_detect_format "${archive_path}")"

		case "${format}" in
		"tar.gz")
			process_run tar -czf "${archive_path}" -C "${source_dir}" . || return 1
			;;
		*)
			log_error "Unsupported archive creation format: ${format}"
			return 1
			;;
		esac

		return 0
	}

	# Extracts an archive to a destination directory
	# Arguments:
	#   $1 - Source archive path
	#   $2 - Destination directory path
	# Returns:
	#   0 on success, 1 on failure
	archive_extract() {
		local archive_path="$1"
		local dest_dir="$2"

		validate_required "${archive_path}" || return 1
		validate_required "${dest_dir}" || return 1
		validate_file "${archive_path}" || return 1

		log_debug "Extracting archive ${archive_path} to ${dest_dir}"

		if ! fs_exists "${dest_dir}"; then
			fs_create_dir "${dest_dir}" || return 1
		fi

		local format
		format="$(archive_detect_format "${archive_path}")"

		case "${format}" in
		"tar.gz")
			process_run tar -xzf "${archive_path}" -C "${dest_dir}" || return 1
			;;
		*)
			log_error "Unsupported archive extraction format: ${format}"
			return 1
			;;
		esac

		return 0
	}

	# Verifies the integrity of an archive
	# Arguments:
	#   $1 - Source archive path
	# Returns:
	#   0 on success, 1 on failure
	archive_verify() {
		local archive_path="$1"
		validate_required "${archive_path}" || return 1

		validate_file "${archive_path}" || return 1

		log_debug "Verifying archive integrity for ${archive_path}"

		local format
		format="$(archive_detect_format "${archive_path}")"

		case "${format}" in
		"tar.gz")
			process_run tar -tzf "${archive_path}" >/dev/null 2>&1 || return 1
			;;
		*)
			log_error "Unsupported archive verification format: ${format}"
			return 1
			;;
		esac

		return 0
	}

fi
