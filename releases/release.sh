_RELEASED_ARTIFACT_FILENAME='ShebangUnit.sh'
_RELEASE_DIRECTORY=$(dirname "${BASH_SOURCE[0]}")
_SOURCES_DIRECTORY="${_RELEASE_DIRECTORY}/../sources/production"
_SOURCES_FILENAMES=('system.sh' 'fileParser.sh' 'assertion.sh' 'runner.sh')

function release_concatenateSourcesInReleaseFile() {
	_initialiseReleaseFile
	local filename; for filename in "${_SOURCES_FILENAMES[@]}"; do
		_concatenateSourceInReleaseFile "${filename}"
	done
}

function _initialiseReleaseFile() {
	_deleteReleaseFileIfExisting
	_printHeaderInReleaseFile
}

function _deleteReleaseFileIfExisting() {
	if [[ -f "$(release_getReleasedArtifactFile)" ]]; then
		rm "$(release_getReleasedArtifactFile)"
	fi
}

function _printHeaderInReleaseFile() {
	local releaseDate=$(date +"%Y-%m-%d_%H-%M-%S")
	printf "# Shebang unit all in one source file\n" >> "$(release_getReleasedArtifactFile)"
}

function _concatenateSourceInReleaseFile() {
	local filename=${1}
	printf "\n#Beginning of ${filename}\n" >> "$(release_getReleasedArtifactFile)"
	cat "${_SOURCES_DIRECTORY}/${filename}" >> "$(release_getReleasedArtifactFile)"
	printf "\n#End of ${filename}\n" >> "$(release_getReleasedArtifactFile)"
}

function release_getReleasedArtifactFile() {
	printf "${_RELEASE_DIRECTORY}/${_RELEASED_ARTIFACT_FILENAME}"
}