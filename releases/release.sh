_RELEASED_ARTIFACT_FILENAME='ShebangUnit.sh'
_RELEASE_DIRECTORY=$(dirname "${BASH_SOURCE[0]}")
_SOURCES_DIRECTORY="${_RELEASE_DIRECTORY}/../sources/production"

function release_concatenateSourcesInReleaseFile() {
	_initialiseReleaseFile
	_concatenateSourcesInReleaseFile
	_makeReleaseFileExecutable
}

function _initialiseReleaseFile() {
	_deleteReleaseFileIfExisting
	_printHeaderInReleaseFile
}

function _concatenateSourcesInReleaseFile() {
	local file; for file in "${_SOURCES_DIRECTORY}"/*.sh; do
		_concatenateSourceInReleaseFile "${file}"
	done
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
	local file=${1}
	local filename=$(basename "${file}")
	printf "\n#Beginning of ${filename}\n" >> "$(release_getReleasedArtifactFile)"
	cat "${file}" >> "$(release_getReleasedArtifactFile)"
	printf "\n#End of ${filename}\n" >> "$(release_getReleasedArtifactFile)"
}

function _makeReleaseFileExecutable() {
	chmod +x "$(release_getReleasedArtifactFile)"
}

function release_getReleasedArtifactFile() {
	printf "${_RELEASE_DIRECTORY}/${_RELEASED_ARTIFACT_FILENAME}"
}