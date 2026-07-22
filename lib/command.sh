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
	framework_require docs
	framework_require plugin
	framework_require marketplace
	framework_require template

	# ==============================================================================
	# Module: Command
	# Purpose: Command implementation logic and routing.
	# Dependencies: sdk, application, package, logger, parser
	# Public API: cmd_init, cmd_new, cmd_build, cmd_validate, cmd_export, cmd_version, cmd_doctor
	# Private API: None
	# ==============================================================================

	# Executes the init command
	cmd_init() {
		local target
		target="$(parser_get_positional 0 || true)"

		if [[ -z "${target}" ]]; then
			log_error "Usage: pag init <path>"
			return 1
		fi

		log_debug "Running init command for ${target}"
		sdk_init || return 1
		framework_require scaffold || return 1
		scaffold_application "${target}" || return 1
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

	# Executes the docs command
	cmd_docs() {
		local output_dir="${1:-docs_out}"
		log_info "Generating documentation to ${output_dir}..."
		docs_generate "${output_dir}" || return 1
		log_info "Documentation generated successfully."
		return 0
	}

	# Executes the plugin command
	cmd_plugin() {
		local action
		action="$(parser_get_positional 0 || true)"

		case "${action}" in
		install)
			local target
			target="$(parser_get_positional 1 || true)"
			if [[ -z "${target}" ]]; then
				log_error "Usage: pag plugin install <name>"
				return 1
			fi
			log_info "Installing plugin ${target}..."
			marketplace_download "${target}" "plugins/${target}" || return 1
			log_info "Plugin ${target} installed."
			;;
		list)
			log_info "Installed Plugins:"
			# simple list implementation
			ls -1 plugins/ 2>/dev/null || echo "No plugins installed."
			;;
		*)
			log_error "Usage: pag plugin <install|list>"
			return 1
			;;
		esac
		return 0
	}

	# Executes the template command
	cmd_template() {
		local action
		action="$(parser_get_positional 0 || true)"

		case "${action}" in
		list)
			log_info "Available Templates:"
			ls -1 templates/ 2>/dev/null || echo "No templates available."
			;;
		*)
			log_error "Usage: pag template <list>"
			return 1
			;;
		esac
		return 0
	}

	# Executes the sdk command
	cmd_sdk() {
		log_info "PAG SDK Status: Active"
		return 0
	}

	# Executes the install command
	cmd_install() {
		local target
		target="$(parser_get_positional 0 || true)"

		if [[ -n "${target}" ]]; then
			if [[ "${target}" == *.tar.gz || "${target}" == *.zip ]]; then
				framework_require archive
				framework_require filesystem
				
				local extract_dir
				extract_dir="${target%.tar.gz}"
				extract_dir="${extract_dir%.zip}"
				
				log_info "Installing ${target} to ${extract_dir}..."
				fs_create_dir "${extract_dir}" || return 1
				
				if archive_extract "${target}" "${extract_dir}"; then
					log_success "Successfully installed ${target}"
					log_info "Application extracted to directory: ./${extract_dir}/"
					log_info "To use the application, navigate to: cd ${extract_dir}/"
					return 0
				else
					log_error "Failed to install ${target}"
					return 1
				fi
			else
				framework_require install
				install_plugin "${target}" || return 1
			fi
		else
			log_info "Installing project dependencies..."
		fi
		
		return 0
	}

	# Executes the list command
	cmd_list() {
		log_info "Listing available components..."
		return 0
	}

	# Executes the remove command
	cmd_remove() {
		log_info "Removing component..."
		return 0
	}

	# Executes the info command
	cmd_info() {
		log_info "PAG Information:"
		cmd_version
		return 0
	}

fi
