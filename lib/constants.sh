#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_CONSTANTS_SH:-}" ]]; then
	readonly _PAG_LIB_CONSTANTS_SH=1

	# ==============================================================================
	# Module: Constants
	# Purpose: Authoritative source for framework-wide constants.
	# Dependencies: None
	# ==============================================================================

	export PAG_VERSION="1.0.0"
readonly PAG_VERSION

fi
