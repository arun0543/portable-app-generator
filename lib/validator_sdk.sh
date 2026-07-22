#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_VALIDATOR_SDK_SH:-}" ]]; then
	readonly _PAG_LIB_VALIDATOR_SDK_SH=1

	framework_require filesystem
	framework_require logger
	framework_require validator
	framework_require manifest

	# ==============================================================================
	# Module: Validator SDK
	# Purpose: SDK validation for project directory layouts and requirements.
	# Dependencies: filesystem, logger, validator
	# Public API: sdk_validate_plugin, sdk_validate_template, sdk_validate_project
	# Private API: None
	# ==============================================================================

	# Validates a plugin project directory layout
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_validate_plugin() {
		local target_dir="$1"
		validate_required "${target_dir}" || return 1
		fs_is_dir "${target_dir}" || return 1

		local file
		for file in "plugin.sh" "plugin.conf" "metadata.conf" "README.md"; do
			if ! fs_is_file "${target_dir}/${file}"; then
				log_error "Plugin validation failed: missing ${file}"
				return 1
			fi
		done

		local dir
		for dir in "hooks" "templates" "assets" "docs" "tests"; do
			if ! fs_is_dir "${target_dir}/${dir}"; then
				log_error "Plugin validation failed: missing directory ${dir}"
				return 1
			fi
		done

		# Validate configuration content
		manifest_validate "${target_dir}/plugin.conf" || return 1

		return 0
	}

	# Validates a template project directory layout
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_validate_template() {
		local target_dir="$1"
		validate_required "${target_dir}" || return 1
		fs_is_dir "${target_dir}" || return 1

		local file
		for file in "template.conf" "variables.conf" "README.md" "LICENSE"; do
			if ! fs_is_file "${target_dir}/${file}"; then
				log_error "Template validation failed: missing ${file}"
				return 1
			fi
		done

		local dir
		for dir in "files" "assets"; do
			if ! fs_is_dir "${target_dir}/${dir}"; then
				log_error "Template validation failed: missing directory ${dir}"
				return 1
			fi
		done

		# Future extension point: Validate template required keys, variable syntax, and placeholder consistency

		return 0
	}

	# Validates an application project directory layout
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_validate_application() {
		local target_dir="$1"
		validate_required "${target_dir}" || return 1
		fs_is_dir "${target_dir}" || return 1

		if ! fs_is_file "${target_dir}/metadata.conf"; then
			log_error "Application validation failed: missing metadata.conf"
			return 1
		fi

		local dir
		for dir in "app" "cache" "config" "data" "desktop" "launcher" "logs" "runtime"; do
			if ! fs_is_dir "${target_dir}/${dir}"; then
				log_error "Application validation failed: missing directory ${dir}"
				return 1
			fi
		done

		return 0
	}

	# Dynamically identifies and validates a generic project
	# Arguments:
	#   $1 - Target directory path
	# Returns:
	#   0 on success, 1 on failure
	sdk_validate_project() {
		local target_dir="$1"
		validate_required "${target_dir}" || return 1

		if fs_is_file "${target_dir}/plugin.sh"; then
			sdk_validate_plugin "${target_dir}" || return 1
		elif fs_is_file "${target_dir}/template.conf"; then
			sdk_validate_template "${target_dir}" || return 1
		elif fs_is_file "${target_dir}/metadata.conf"; then
			sdk_validate_application "${target_dir}" || return 1
		else
			log_error "Unknown project type at ${target_dir}"
			return 1
		fi

		return 0
	}

fi
