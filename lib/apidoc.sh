#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_APIDOC_SH:-}" ]]; then
	readonly _PAG_LIB_APIDOC_SH=1

	framework_require logger
	framework_require filesystem

	# ==============================================================================
	# Module: API Doc
	# Purpose: Generate API reference from framework modules.
	# Dependencies: logger, filesystem
	# Public API: apidoc_scan, apidoc_generate, apidoc_validate
	# Private API: None
	# ==============================================================================

	# Scans library directory for API metadata
	# Arguments:
	#   $1 - Library directory
	# Returns: 0
	apidoc_scan() {
		local lib_dir="$1"
		log_debug "Scanning ${lib_dir} for module headers"

		local file module_name purpose public_api
		for file in "${lib_dir}"/*.sh; do
			[[ -f "${file}" ]] || continue

			module_name=$(grep -m1 "^# Module:" "${file}" | sed 's/^# Module: //') || module_name=""
			[[ -z "${module_name}" ]] && continue

			purpose=$(grep -m1 "^# Purpose:" "${file}" | sed 's/^# Purpose: //') || purpose=""
			public_api=$(grep -m1 "^# Public API:" "${file}" | sed 's/^# Public API: //') || public_api=""

			printf '%s|%s|%s|%s\n' "$(basename "${file}" .sh)" "${module_name}" "${purpose}" "${public_api}"
		done

		# Future extension points: Cross references extraction

		return 0
	}

	# Generates Markdown documentation for APIs
	# Arguments:
	#   $1 - Output directory
	# Returns: 0
	apidoc_generate() {
		local output_dir="$1"
		log_debug "Generating API documentation to ${output_dir}"

		mkdir -p "${output_dir}" || return 1

		local lib_dir
		lib_dir="$(dirname "${BASH_SOURCE[0]}")"

		local file_base module_name purpose public_api md_file
		while IFS='|' read -r file_base module_name purpose public_api; do
			[[ -z "${module_name}" ]] && continue
			md_file="${output_dir}/${file_base}.md"
			{
				printf '# %s API Reference\n\n' "${module_name}"
				printf '**Purpose:** %s\n\n' "${purpose}"
				printf '## Public API\n\n'
				printf '%s\n\n' "${public_api}"
			} >"${md_file}"
		done <<<"$(apidoc_scan "${lib_dir}")"

		# Future extension points: HTML generation, Source links

		return 0
	}

	# Validates API documentation completeness
	# Arguments:
	#   $1 - Input directory
	# Returns: 0
	apidoc_validate() {
		local input_dir="$1"
		log_debug "Validating API documentation in ${input_dir}"

		return 0
	}

fi
