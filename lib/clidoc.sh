#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CLIDOC_SH:-}" ]]; then
	readonly _PAG_LIB_CLIDOC_SH=1

	framework_require logger
	framework_require registry_cli

	# ==============================================================================
	# Module: CLI Doc
	# Purpose: Generate CLI reference.
	# Dependencies: logger
	# Public API: clidoc_generate, clidoc_commands, clidoc_options
	# Private API: None
	# ==============================================================================

	# Generates Markdown CLI reference
	# Arguments:
	#   $1 - Output directory
	# Returns: 0
	clidoc_generate() {
		local output_dir="$1"
		log_debug "Generating CLI documentation to ${output_dir}"

		mkdir -p "${output_dir}" || return 1

		local cmd_list
		cmd_list="$(clidoc_commands)" || return 1

		local md_file="${output_dir}/commands.md"
		{
			printf '# PAG CLI Reference\n\n'
			printf '## Available Commands\n\n'

			local cmd
			for cmd in ${cmd_list}; do
				printf "* \`pag %s\`\n" "${cmd}"
			done

			printf '\n## Global Options\n\n'
			clidoc_options
		} >"${md_file}"

		# Future extension points: Shell examples, Interactive help

		return 0
	}

	# Extracts command metadata from CLI registry
	# Arguments: None
	# Returns: 0
	clidoc_commands() {
		log_debug "Extracting CLI commands metadata" >&2
		cli_get_registered_commands
		return 0
	}

	# Extracts options metadata from CLI registry
	# Arguments: None
	# Returns: 0
	clidoc_options() {
		log_debug "Extracting CLI options metadata" >&2
		printf "* \`--help, -h\`: Show help\n"
		printf "* \`--verbose, -v\`: Enable verbose logging\n"
		printf "* \`--version, -V\`: Show version\n"
		return 0
	}

fi
