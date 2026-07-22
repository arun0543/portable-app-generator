#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_REPOSITORY_SH:-}" ]]; then
readonly _PAG_LIB_REPOSITORY_SH=1

framework_require logger
framework_require config

# ==============================================================================
# Module: Repository
# Purpose: Repository management for marketplace sources.
# Dependencies: logger
# Public API: repository_add, repository_remove, repository_list, repository_verify
# Private API: None
# ==============================================================================

readonly _PAG_REPO_CONF="${PAG_CONFIG_DIR:-${HOME}/.config/pag}/repositories.conf"

# Adds a new trusted repository
# Arguments:
#   $1 - Repository name
#   $2 - Repository URL or local path
# Returns: 0 on success, 1 on failure
repository_add() {
	local name="$1"
	local url="$2"
	
	if config_exists "${_PAG_REPO_CONF}" "${name}"; then
		log_error "Repository already exists: ${name}"
		return 1
	fi
	
	config_write "${_PAG_REPO_CONF}" "${name}" "${url}" "false"
	log_debug "Added repository ${name} -> ${url}"
	
	# Future extension points: Mirror repositories, Repository priorities, Repository authentication
	
	return 0
}

# Removes a repository
# Arguments:
#   $1 - Repository name
# Returns: 0 on success, 1 on failure
repository_remove() {
	local name="$1"
	
	if ! config_exists "${_PAG_REPO_CONF}" "${name}"; then
		log_error "Repository not found: ${name}"
		return 1
	fi
	
	config_remove "${_PAG_REPO_CONF}" "${name}"
	log_debug "Removed repository ${name}"
	
	return 0
}

# Lists all configured repositories
# Arguments: None
# Returns: 0
repository_list() {
	if [[ ! -f "${_PAG_REPO_CONF}" ]]; then
		return 0
	fi
	
	local line key val
	while IFS= read -r line || [[ -n "${line}" ]]; do
		[[ -z "${line}" || "${line}" == "#"* ]] && continue
		key="${line%%=*}"
		val="${line#*=}"
		printf '%s %s\n' "${key}" "${val}"
	done <"${_PAG_REPO_CONF}"
	return 0
}

# Verifies the metadata of a repository
# Arguments:
#   $1 - Repository name
# Returns: 0 on success, 1 on failure
repository_verify() {
	local name="$1"
	
	if [[ -z "${_PAG_REPOSITORIES[${name}]:-}" ]]; then
		log_error "Repository not found: ${name}"
		return 1
	fi
	
	log_debug "Verifying repository metadata for ${name}"
	
	# Future extension point: Remote validation and cryptographic trust policies
	
	return 0
}

fi
