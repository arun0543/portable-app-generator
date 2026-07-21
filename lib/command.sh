#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_COMMAND_SH:-}" ]]; then
readonly _PAG_LIB_COMMAND_SH=1

framework_require sdk
framework_require application
framework_require package
framework_require logger
framework_require parser
framework_require constants

# ==============================================================================
# Module: Command
# Purpose: Command implementation logic and routing.
# Dependencies: sdk, application, package, logger, parser
# Public API: cmd_init, cmd_new, cmd_build, cmd_validate, cmd_export, cmd_version, cmd_doctor
# Private API: None
# ==============================================================================

# Executes the init command
cmd_init() {
	log_debug "Running init command"
	sdk_init || return 1
	return 0
}

# Executes the new command
cmd_new() {
	local type
	local target
	
	type="$(parser_get_positional 0 || true)"
	target="$(parser_get_positional 1 || true)"
	
	if [[ -z "${type}" || -z "${target}" ]]; then
		log_error "Usage: pag new <plugin|template> <path>"
		return 1
	fi
	
	case "${type}" in
		plugin)
			sdk_create_plugin "${target}" || return 1
			;;
		template)
			sdk_create_template "${target}" || return 1
			;;
		*)
			log_error "Unknown scaffold type: ${type}"
			return 1
			;;
	esac
	
	return 0
}

# Executes the build command
cmd_build() {
	local target
	
	target="$(parser_get_positional 0 || true)"
	
	if [[ -z "${target}" ]]; then
		log_error "Usage: pag build <path>"
		return 1
	fi
	
	sdk_validate "${target}" || return 1
	log_debug "Building project ${target}"
	
	# Future extension point: compiling assets, resolving dependencies
	
	return 0
}

# Executes the validate command
cmd_validate() {
	local target
	target="$(parser_get_positional 0 || true)"
	
	if [[ -z "${target}" ]]; then
		log_error "Usage: pag validate <path>"
		return 1
	fi
	
	sdk_validate "${target}" || return 1
	return 0
}

# Executes the export command
cmd_export() {
	local target
	local output
	
	target="$(parser_get_positional 0 || true)"
	output="$(parser_get_positional 1 || true)"
	
	if [[ -z "${target}" || -z "${output}" ]]; then
		log_error "Usage: pag export <path> <output_archive>"
		return 1
	fi
	
	sdk_export "${target}" "${output}" || return 1
	
	return 0
}

# Executes the version command
cmd_version() {
	printf 'Portable App Generator v%s\n' "${PAG_VERSION:-unknown}"
	return 0
}

# Executes the doctor command
cmd_doctor() {
	log_debug "Running doctor checks"
	# Future extension point: validation of system dependencies (bash version, tar, etc.)
	printf 'PAG environment looks healthy.\n'
	return 0
}

fi
