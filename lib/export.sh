#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_EXPORT_SH:-}" ]]; then
	readonly _PAG_LIB_EXPORT_SH=1

	framework_require archive
	framework_require filesystem
	framework_require logger
	framework_require validator

	# ==============================================================================
	# Module: Export
	# Purpose: Export SDK artifacts into distributable packages.
	# Dependencies: archive, filesystem, logger, validator
	# Public API: export_plugin, export_template, export_project
	# Private API: _export_archive
	# ==============================================================================

	# Internal helper to export a directory to an archive
	# Arguments:
	#   $1 - Source directory path
	#   $2 - Output archive path
	#   $3 - Project type name for logging
	# Returns:
	#   0 on success, 1 on failure
	_export_archive() {
		local source_dir="$1"
		local output_archive="$2"
		local type_name="$3"

		validate_required "${source_dir}" || return 1
		validate_required "${output_archive}" || return 1
		fs_is_dir "${source_dir}" || return 1

		log_debug "Exporting ${type_name} ${source_dir} to ${output_archive}"

		archive_create "${source_dir}" "${output_archive}" || return 1

		return 0
	}

	# Exports a plugin project to an archive
	# Arguments:
	#   $1 - Source directory path
	#   $2 - Output archive path
	# Returns:
	#   0 on success, 1 on failure
	export_plugin() {
		_export_archive "$1" "$2" "plugin"
	}

	# Exports a template project to an archive
	# Arguments:
	#   $1 - Source directory path
	#   $2 - Output archive path
	# Returns:
	#   0 on success, 1 on failure
	export_template() {
		_export_archive "$1" "$2" "template"
	}

	# Exports a generic project to an archive
	# Arguments:
	#   $1 - Source directory path
	#   $2 - Output archive path
	# Returns:
	#   0 on success, 1 on failure
	export_project() {
		_export_archive "$1" "$2" "project"
	}

fi
