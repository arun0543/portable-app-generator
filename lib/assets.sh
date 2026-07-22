#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_ASSETS_SH:-}" ]]; then
readonly _PAG_LIB_ASSETS_SH=1

framework_require filesystem
framework_require validator
framework_require logger
framework_require process

# ==============================================================================
# Module: Assets
# Purpose: Manage application assets.
# Dependencies: filesystem, validator, logger
# Public API: assets_install, assets_remove, assets_verify
# Private API: None
# ==============================================================================

# Copies assets to the application destination
# Arguments:
#   $1 - Source asset path (file or directory)
#   $2 - Destination asset path
# Returns:
#   0 on success, 1 on failure
assets_install() {
	local source_asset="$1"
	local dest_asset="$2"

	validate_required "${source_asset}" || return 1
	validate_required "${dest_asset}" || return 1
	fs_exists "${source_asset}" || return 1

	log_debug "Installing asset from ${source_asset} to ${dest_asset}"

	# Future extension point: Asset optimization, resource format validation
	process_run cp -R "${source_asset}" "${dest_asset}" || return 1

	return 0
}

# Removes assets safely
# Arguments:
#   $1 - Destination asset path
# Returns:
#   0 on success, 1 on failure
assets_remove() {
	local dest_asset="$1"
	validate_required "${dest_asset}" || return 1

	if fs_exists "${dest_asset}"; then
		log_debug "Removing asset ${dest_asset}"
		fs_remove "${dest_asset}" || return 1
	fi

	return 0
}

# Verifies asset existence
# Arguments:
#   $1 - Destination asset path
# Returns:
#   0 on success, 1 on failure
assets_verify() {
	local dest_asset="$1"
	validate_required "${dest_asset}" || return 1

	fs_exists "${dest_asset}" || return 1

	return 0
}

fi
