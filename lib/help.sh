#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_HELP_SH:-}" ]]; then
	readonly _PAG_LIB_HELP_SH=1

	# ==============================================================================
	# Module: Help
	# Purpose: Formatting and displaying CLI help information.
	# Dependencies: None
	# Public API: help_print_global, help_print_command
	# Private API: None
	# ==============================================================================

	# Prints global help documentation
	# Arguments: None
	# Returns: 0
	help_print_global() {
		cat <<'EOF'
Portable App Generator (PAG)

Usage:
  pag <command> [subcommand] [flags] [args]

Commands:
  init       Initialize the PAG environment
  new        Scaffold a new project (plugin, template)
  build      Build an artifact from a project
  validate   Validate a project layout and manifest
  export     Export a project to a distributable archive
  install    Install an application or plugin
  remove     Remove an application or plugin
  list       List installed applications or plugins
  info       Show information about a project
  doctor     Check system dependencies and environment
  version    Show version information
  help       Show help for a command

Flags:
  -h, --help       Show help message
  -v, --verbose    Enable verbose logging
  -d, --debug      Enable debug logging

Run 'pag help <command>' for more information on a command.
EOF
		return 0
	}

	# Prints command-specific help documentation
	# Arguments:
	#   $1 - Command name
	# Returns: 0
	help_print_command() {
		local cmd="$1"
		# Future extension point: dynamic command help lookup and plugin command help
		case "${cmd}" in
		new)
			cat <<'EOF'
Usage: pag new <type> <path>

Types:
  plugin     Scaffold a new plugin project
  template   Scaffold a new template project
EOF
			;;
		build | export)
			cat <<'EOF'
Usage: pag build <path> <output_archive>

Builds or exports a project into a distributable archive format.
EOF
			;;
		validate)
			cat <<'EOF'
Usage: pag validate <path>

Validates the layout and manifest of a project directory.
EOF
			;;
		*)
			printf 'No detailed help available for command: %s\n' "${cmd}"
			;;
		esac
		return 0
	}

fi
