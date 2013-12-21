#!/bin/bash

_SUITE_DIRECTORY="$(dirname ${BASH_SOURCE[0]})"

function _releaseShebangUnit() {
	source ${_SUITE_DIRECTORY}/../../releases/release.sh
	release::concatenate_sources_in_release_file
	source "$(release::get_released_artifact_file)"
}

_releaseShebangUnit
runner::run_all_test_files_in_directory "${_SUITE_DIRECTORY}" $@