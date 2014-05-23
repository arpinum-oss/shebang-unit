_SBU_RELEASED_ARTIFACT_FILENAME='shebang_unit'
_SBU_SOURCES_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_SBU_RELEASE_DIRECTORY="${_SBU_SOURCES_DIRECTORY}/../../releases"

_SBU_ORDERED_SOURCES=('header.sh' 'configuration.sh' 'system.sh' 'assertion.sh'
                  'parser.sh' 'runner.sh' 'file_runner.sh' 'main.sh')

function release__concatenate_sources_in_release_file() {
	_release__initialise
	_release__concatenate_sources_in_release_file
	_release__append_runner_call_in_release_file
	_release__make_release_file_executable
}

function _release__initialise() {
	_release__delete_release_file_if_existing
	mkdir -p "${_SBU_RELEASE_DIRECTORY}"
}

function _release__delete_release_file_if_existing() {
	echo "$(release__get_released_artifact_file)"
	if [[ -f "$(release__get_released_artifact_file)" ]]; then
		rm "$(release__get_released_artifact_file)"
	fi
}

function _release__concatenate_sources_in_release_file() {
	local file
	for file in "${_SBU_ORDERED_SOURCES[@]}"; do
		_release__append_file_to_release_file "${_SBU_SOURCES_DIRECTORY}/${file}"
	done
}

function _release__append_runner_call_in_release_file() {
	_release__append_to_release_file 'main__main $@'
}

function _release__append_file_to_release_file() {
	cat "$1" >> "$(release__get_released_artifact_file)"
	_release__append_to_release_file "\n\n"
}

function _release__make_release_file_executable() {
	chmod +x "$(release__get_released_artifact_file)"
}

function _release__append_to_release_file() {
  printf "$1" >> "$(release__get_released_artifact_file)"
}

function release__get_released_artifact_file() {
	printf "${_SBU_RELEASE_DIRECTORY}/${_SBU_RELEASED_ARTIFACT_FILENAME}"
}