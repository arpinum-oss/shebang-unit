#!/bin/bash

_SUITE_DIRECTORY="$(dirname ${BASH_SOURCE[0]})"

function _releaseShebangUnit() {
	source ${_SUITE_DIRECTORY}/../../releases/release.sh
	release::concatenateSourcesInReleaseFile
	source "$(release::getReleasedArtifactFile)"
}

_releaseShebangUnit
runner::runAllTestFilesInDirectory "${_SUITE_DIRECTORY}" $@