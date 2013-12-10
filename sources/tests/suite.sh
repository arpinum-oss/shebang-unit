#!/bin/bash

_SUITE_DIRECTORY="$(dirname ${BASH_SOURCE[0]})"

function _releaseShebangUnit() {
	source ${_SUITE_DIRECTORY}/../../releases/release.sh
	release_concatenateSourcesInReleaseFile
	source "$(release_getReleasedArtifactFile)"
}

_releaseShebangUnit
runner_runAllTestFilesInDirectory "${_SUITE_DIRECTORY}" ${@}