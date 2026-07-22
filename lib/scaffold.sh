#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_SCAFFOLD_SH:-}" ]]; then
readonly _PAG_LIB_SCAFFOLD_SH=1

framework_require filesystem
framework_require logger
framework_require validator
framework_require template

# ==============================================================================
# Module: Scaffold
# Purpose: Filesystem scaffolding.
# Dependencies: filesystem, logger, validator
# Public API: scaffold_plugin, scaffold_template, scaffold_application
# Private API: None
# ==============================================================================

readonly PAG_PLUGIN_DIRS=("hooks" "templates" "assets" "docs" "tests")
readonly PAG_TEMPLATE_DIRS=("files" "assets")

# Scaffolds a new plugin project
# Arguments:
#   $1 - Destination directory path
# Returns:
#   0 on success, 1 on failure
scaffold_plugin() {
	local dest_dir="$1"
	validate_required "${dest_dir}" || return 1

	if fs_exists "${dest_dir}"; then
		log_error "Plugin project already exists at ${dest_dir}"
		return 1
	fi

	log_debug "Scaffolding plugin project at ${dest_dir}"
	fs_create_dir "${dest_dir}" || return 1

	local dir
	for dir in "${PAG_PLUGIN_DIRS[@]}"; do
		fs_create_dir "${dest_dir}/${dir}" || return 1
	done

	local scaffold_base="${PAG_SCAFFOLD_DIR:-${PAG_ROOT_DIR:-.}/scaffolds}/plugin"

	if fs_is_dir "${scaffold_base}"; then
		template_write "${scaffold_base}/README.md" "${dest_dir}/README.md"
		template_write "${scaffold_base}/plugin.conf" "${dest_dir}/plugin.conf"
		template_write "${scaffold_base}/metadata.conf" "${dest_dir}/metadata.conf"
		template_write "${scaffold_base}/plugin.sh" "${dest_dir}/plugin.sh"
	else
		printf '# Plugin Project\n' >"${dest_dir}/README.md" || return 1
		printf 'name=\nversion=\napi_version=\nauthor=\ndescription=\n' >"${dest_dir}/plugin.conf" || return 1
		printf '' >"${dest_dir}/metadata.conf" || return 1
		printf '#!/usr/bin/env bash\n' >"${dest_dir}/plugin.sh" || return 1
	fi

	fs_make_executable "${dest_dir}/plugin.sh" || return 1

	return 0
}

# Scaffolds a new template project
# Arguments:
#   $1 - Destination directory path
# Returns:
#   0 on success, 1 on failure
scaffold_template() {
	local dest_dir="$1"
	validate_required "${dest_dir}" || return 1

	if fs_exists "${dest_dir}"; then
		log_error "Template project already exists at ${dest_dir}"
		return 1
	fi

	log_debug "Scaffolding template project at ${dest_dir}"
	fs_create_dir "${dest_dir}" || return 1

	local dir
	for dir in "${PAG_TEMPLATE_DIRS[@]}"; do
		fs_create_dir "${dest_dir}/${dir}" || return 1
	done

	local scaffold_base="${PAG_SCAFFOLD_DIR:-${PAG_ROOT_DIR:-.}/scaffolds}/template"

	if fs_is_dir "${scaffold_base}"; then
		template_write "${scaffold_base}/README.md" "${dest_dir}/README.md"
		template_write "${scaffold_base}/template.conf" "${dest_dir}/template.conf"
		template_write "${scaffold_base}/variables.conf" "${dest_dir}/variables.conf"
		template_write "${scaffold_base}/LICENSE" "${dest_dir}/LICENSE"
	else
		printf '# Template Project\n' >"${dest_dir}/README.md" || return 1
		printf 'name=\nversion=\n' >"${dest_dir}/template.conf" || return 1
		printf '' >"${dest_dir}/variables.conf" || return 1
		printf '' >"${dest_dir}/LICENSE" || return 1
	fi

	return 0
}

# Scaffolds a new application
# Arguments:
#   $1 - Destination directory path
# Returns:
#   0 on success, 1 on failure
scaffold_application() {
	local dest_dir="$1"
	validate_required "${dest_dir}" || return 1

	if fs_exists "${dest_dir}"; then
		log_error "Application project already exists at ${dest_dir}"
		return 1
	fi

	log_debug "Scaffolding application at ${dest_dir}"
	framework_require application || return 1

	application_create "${dest_dir}" || return 1

	return 0
}

fi
