#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CONFIG_SH:-}" ]]; then
	readonly _PAG_LIB_CONFIG_SH=1

	# ==============================================================================
	# Module: Configuration
	# Purpose: Provides helpers for reading and writing KEY=VALUE configuration files.
	# Dependencies: grep, head, sed, mktemp, cat, rm, mv, chmod
	# Public API: config_exists, config_read, config_write, config_remove
	# Private API: None
	# ==============================================================================

	# Checks if a configuration key exists in the specified file.
	# Arguments:
	#   $1 - Path to the configuration file
	#   $2 - Configuration key to check
	# Returns:
	#   0 if the key exists, 1 otherwise
	config_exists() {
		local file="$1"
		local search_key="$2"

		[[ -f "${file}" ]] || return 1
		[[ -n "${search_key}" ]] || return 1

		local line key
		while IFS= read -r line || [[ -n "${line}" ]]; do
			# Ignore blank lines and comments
			[[ -z "${line}" || "${line}" == "#"* ]] && continue

			key="${line%%=*}"
			if [[ "${key}" == "${search_key}" ]]; then
				return 0
			fi
		done <"${file}"

		return 1
	}

	# Reads the value of a configuration key from the specified file.
	# Arguments:
	#   $1 - Path to the configuration file
	#   $2 - Configuration key to read
	# Returns:
	#   0 on success (and prints value), 1 on failure
	config_read() {
		local file="$1"
		local search_key="$2"

		[[ -f "${file}" ]] || return 1
		[[ -n "${search_key}" ]] || return 1

		local line key val
		while IFS= read -r line || [[ -n "${line}" ]]; do
			[[ -z "${line}" || "${line}" == "#"* ]] && continue

			key="${line%%=*}"
			if [[ "${key}" == "${search_key}" ]]; then
				val="${line#*=}"
				printf '%s\n' "${val}"
				return 0
			fi
		done <"${file}"

		return 1
	}

	# Writes a configuration key and value to the specified file.
	# Arguments:
	#   $1 - Path to the configuration file
	#   $2 - Configuration key
	#   $3 - Configuration value
	#   $4 - (Optional) Set to "true" to overwrite an existing key
	# Returns:
	#   0 on success, 1 on failure
	config_write() {
		local file="$1"
		local search_key="$2"
		local new_val="$3"
		local overwrite="${4:-false}"

		[[ -n "${file}" ]] || return 1
		[[ -n "${search_key}" ]] || return 1

		if [[ ! -f "${file}" ]]; then
			touch "${file}" 2>/dev/null || return 1
		fi

		if config_exists "${file}" "${search_key}"; then
			if [[ "${overwrite}" != "true" ]]; then
				return 1
			fi

			local tmp_file
			tmp_file="$(mktemp)" || return 1

			local line key found="false"
			while IFS= read -r line || [[ -n "${line}" ]]; do
				if [[ -z "${line}" || "${line}" == "#"* ]]; then
					printf '%s\n' "${line}" >>"${tmp_file}"
					continue
				fi

				key="${line%%=*}"
				if [[ "${key}" == "${search_key}" ]]; then
					if [[ "${found}" == "false" ]]; then
						printf '%s=%s\n' "${search_key}" "${new_val}" >>"${tmp_file}"
						found="true"
					fi
				else
					printf '%s\n' "${line}" >>"${tmp_file}"
				fi
			done <"${file}"

			# Atomic replacement preserving permissions
			chmod --reference="${file}" "${tmp_file}" 2>/dev/null || true
			mv -f "${tmp_file}" "${file}" || return 1
		else
			printf '%s=%s\n' "${search_key}" "${new_val}" >>"${file}" || return 1
		fi

		return 0
	}

	# Removes a configuration key from the specified file.
	# Arguments:
	#   $1 - Path to the configuration file
	#   $2 - Configuration key to remove
	# Returns:
	#   0 on success, 1 on failure
	config_remove() {
		local file="$1"
		local search_key="$2"

		[[ -f "${file}" ]] || return 1
		[[ -n "${search_key}" ]] || return 1

		if ! config_exists "${file}" "${search_key}"; then
			return 0
		fi

		local tmp_file
		tmp_file="$(mktemp)" || return 1

		local line key
		while IFS= read -r line || [[ -n "${line}" ]]; do
			if [[ -z "${line}" || "${line}" == "#"* ]]; then
				printf '%s\n' "${line}" >>"${tmp_file}"
				continue
			fi

			key="${line%%=*}"
			if [[ "${key}" != "${search_key}" ]]; then
				printf '%s\n' "${line}" >>"${tmp_file}"
			fi
		done <"${file}"

		# Atomic replacement preserving permissions
		chmod --reference="${file}" "${tmp_file}" 2>/dev/null || true
		mv -f "${tmp_file}" "${file}" || return 1

		return 0
	}

fi
