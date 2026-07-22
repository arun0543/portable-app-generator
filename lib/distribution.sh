#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -z "${_PAG_LIB_DISTRIBUTION_SH:-}" ]]; then
	readonly _PAG_LIB_DISTRIBUTION_SH=1

	framework_require logger
	framework_require package_manager
	framework_require appimage
	framework_require checksum
	framework_require signing
	framework_require release

	# ==============================================================================
	# Module: Distribution
	# Purpose: Top-level distribution coordinator.
	# Dependencies: logger, package_manager, appimage, checksum, signing, release
	# Public API: distribution_build, distribution_verify, distribution_publish
	# Private API: None
	# ==============================================================================

	declare -ag _PAG_DISTRIBUTION_STEPS=()

	# Registers a build step in the pipeline
	distribution_register_step() {
		local step_func="$1"
		_PAG_DISTRIBUTION_STEPS+=("${step_func}")
		return 0
	}

	_dist_step_prepare() {
		release_prepare "$2"
	}

	_dist_step_package() {
		local source_dir="$1"
		local release_dir="$2"
		local version="$3"

		local formats
		if ! formats="$(package_detect 2>/dev/null)"; then
			log_debug "No native packagers detected, skipping packages"
		else
			local fmt
			for fmt in ${formats}; do
				case "${fmt}" in
				deb) package_deb "${source_dir}" "${release_dir}/app-${version}.deb" || true ;;
				rpm) package_rpm "${source_dir}" "${release_dir}/app-${version}.rpm" || true ;;
				esac
			done
		fi
		return 0
	}

	_dist_step_appimage() {
		appimage_create "$1" "$2/app-$3.AppImage" || true
	}

	_dist_step_checksum() {
		local artifact
		for artifact in "$2"/*; do
			if [[ -f "${artifact}" && "${artifact}" != *.sha256 && "${artifact}" != *.sig && "$(basename "${artifact}")" != "release.json" ]]; then
				checksum_generate "${artifact}" "sha256" "${artifact}.sha256" || return 1
			fi
		done
		return 0
	}

	_dist_step_sign() {
		local artifact
		for artifact in "$2"/*; do
			if [[ -f "${artifact}" && "${artifact}" != *.sha256 && "${artifact}" != *.sig && "$(basename "${artifact}")" != "release.json" ]]; then
				signing_sign "${artifact}" "${artifact}.sig" "gpg" || log_debug "Skipping signing for ${artifact}"
			fi
		done
		return 0
	}

	_dist_step_manifest() {
		release_manifest "$2" "$3"
	}

	distribution_register_step "_dist_step_prepare"
	distribution_register_step "_dist_step_package"
	distribution_register_step "_dist_step_appimage"
	distribution_register_step "_dist_step_checksum"
	distribution_register_step "_dist_step_sign"
	distribution_register_step "_dist_step_manifest"

	# Builds a complete distributable release artifact set
	# Arguments:
	#   $1 - Source payload directory
	#   $2 - Target release directory
	#   $3 - Version string
	# Returns: 0 on success, 1 on failure
	distribution_build() {
		local source_dir="$1"
		local release_dir="$2"
		local version="$3"

		log_debug "Starting distribution build for version ${version}"

		local step
		for step in "${_PAG_DISTRIBUTION_STEPS[@]}"; do
			log_debug "Executing distribution step: ${step}"
			if ! "${step}" "${source_dir}" "${release_dir}" "${version}"; then
				log_error "Distribution step failed: ${step}"
				return 1
			fi
		done

		return 0
	}

	# Verifies the integrity of a distribution release
	# Arguments:
	#   $1 - Target release directory
	# Returns: 0 on success, 1 on failure
	distribution_verify() {
		local release_dir="$1"

		log_debug "Verifying distribution artifacts in ${release_dir}"

		local checksum_file
		for checksum_file in "${release_dir}"/*.sha256; do
			if [[ -f "${checksum_file}" ]]; then
				checksum_verify "${checksum_file}" "sha256" || return 1
			fi
		done

		local sig_file
		for sig_file in "${release_dir}"/*.sig; do
			if [[ -f "${sig_file}" ]]; then
				local target="${sig_file%.sig}"
				signing_verify "${target}" "${sig_file}" "gpg" || return 1
			fi
		done

		return 0
	}

	# Publishes a verified distribution
	# Arguments:
	#   $1 - Target release directory
	# Returns: 0 on success, 1 on failure
	distribution_publish() {
		local release_dir="$1"

		log_debug "Publishing distribution from ${release_dir}"

		distribution_verify "${release_dir}" || return 1

		release_finalize "${release_dir}" || return 1

		# Future extension points: GitHub Releases, GitLab Releases, S3,
		# OCI Registry, automatic update feeds

		return 0
	}

fi
