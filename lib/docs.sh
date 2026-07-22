#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_DOCS_SH:-}" ]]; then
	readonly _PAG_LIB_DOCS_SH=1

	framework_require logger
	framework_require apidoc
	framework_require clidoc
	framework_require manpage
	framework_require site
	framework_require linter

	# ==============================================================================
	# Module: Docs
	# Purpose: Documentation orchestration.
	# Dependencies: logger, apidoc, clidoc, manpage, site, linter
	# Public API: docs_generate, docs_clean, docs_validate
	# Private API: None
	# ==============================================================================

	# Generates all documentation artifacts
	# Arguments:
	#   $1 - Output directory
	# Returns: 0 on success, 1 on failure
	docs_generate() {
		local output_dir="$1"

		log_debug "Starting documentation generation in ${output_dir}"

		apidoc_generate "${output_dir}/api" || return 1
		clidoc_generate "${output_dir}/cli" || return 1
		manpage_generate "${output_dir}/man" || return 1
		site_build "${output_dir}/site" || return 1

		# Future extension points: Multi-language documentation, Versioned documentation, Plugin documentation, PDF documentation, ePub export

		return 0
	}

	# Cleans generated documentation
	# Arguments:
	#   $1 - Output directory
	# Returns: 0
	docs_clean() {
		local output_dir="$1"

		log_debug "Cleaning documentation in ${output_dir}"
		site_clean "${output_dir}/site" || return 1

		return 0
	}

	# Validates all documentation
	# Arguments:
	#   $1 - Documentation directory
	# Returns: 0 on success, 1 on failure
	docs_validate() {
		local output_dir="$1"

		log_debug "Validating documentation in ${output_dir}"

		linter_docs "${output_dir}" || return 1

		return 0
	}

fi
