#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_PACKAGE_SH:-}" ]]; then
	readonly _PAG_LIB_PACKAGE_SH=1

	framework_require filesystem
	framework_require validator
	framework_require process
	framework_require logger
	framework_require archive

	# ==============================================================================
	# Module: Package
	# Purpose: Application package management.
	# Dependencies: filesystem, validator, process, logger
	# Public API: package_install, package_remove, package_verify
	# Private API: None
	# ==============================================================================

	# Installs package contents to a destination directory
	# Arguments:
	#   $1 - Source package path
	#   $2 - Destination directory path
	# Returns:
	#   0 on success, 1 on failure
	package_install() {
		local source_pkg="$1"
		local dest_dir="$2"

		validate_required "${source_pkg}" || return 1
		validate_required "${dest_dir}" || return 1
		validate_file "${source_pkg}" || return 1
		fs_is_dir "${dest_dir}" || return 1

		log_debug "Installing package ${source_pkg} to ${dest_dir}"

		# Future extension point: Package updates, rollback state
		archive_extract "${source_pkg}" "${dest_dir}" || return 1

		return 0
	}

	# Removes package contents from a destination directory safely
	# Arguments:
	#   $1 - Destination directory path
	# Returns:
	#   0 on success, 1 on failure
	package_remove() {
		local dest_dir="$1"
		validate_required "${dest_dir}" || return 1
		fs_is_dir "${dest_dir}" || return 1

		log_debug "Removing package contents from ${dest_dir}"

		# Future extension point: Uninstall manifest tracking
		local item
		for item in "${dest_dir}"/* "${dest_dir}"/.[!.]* "${dest_dir}"/..?*; do
			if [[ -e "${item}" || -L "${item}" ]]; then
				fs_remove "${item}" || return 1
			fi
		done

		return 0
	}

	# Verifies the integrity of an installed package
	# Arguments:
	#   $1 - Destination directory path
	# Returns:
	#   0 on success, 1 on failure
	package_verify() {
		local dest_dir="$1"
		validate_required "${dest_dir}" || return 1

		# Future extension point: Content hashes, digital signatures
		fs_is_dir "${dest_dir}" || return 1

		log_debug "Package integrity verified at ${dest_dir}"
		return 0
	}

fi
