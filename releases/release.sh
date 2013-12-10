_RELEASE_DIRECTORY=$(dirname "${BASH_SOURCE[0]}")
_RELEASE_FILENAME=SheBangUnit.sh
_SOURCES_DIRECTORY="${_RELEASE_DIRECTORY}/../sources/production"
_SOURCE_FILENAMES=('system.sh' 'fileParser.sh' 'assertion.sh' 'runner.sh')

function _concatenateSourcesInReleaseFile() {
	_initialiseReleaseFile
	local filename; for filename in "${_SOURCE_FILENAMES[@]}"; do
		_concatenateSourceInReleaseFile "${filename}"
	done
}

function _initialiseReleaseFile() {
	_deleteReleaseFileIfExisting
	_printHeaderInReleaseFile
}

function _deleteReleaseFileIfExisting() {
	if [[ -f "$(_getReleaseFile)" ]]; then
		rm "$(_getReleaseFile)"
	fi
}

function _printHeaderInReleaseFile() {
	local releaseDate=$(date +"%Y-%m-%d_%H-%M-%S")
	printf "#Last release: ${releaseDate}\n" >> "$(_getReleaseFile)"
}

function _concatenateSourceInReleaseFile() {
	local filename=${1}
	printf "\n#Beginning of ${filename}\n" >> "$(_getReleaseFile)"
	cat "${_SOURCES_DIRECTORY}/${filename}" >> "$(_getReleaseFile)"
	printf "\n#End of ${filename}\n" >> "$(_getReleaseFile)"
}

function _getReleaseFile() {
	printf "${_RELEASE_DIRECTORY}/${_RELEASE_FILENAME}"
}

_concatenateSourcesInReleaseFile