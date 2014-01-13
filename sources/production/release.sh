_RELEASED_ARTIFACT_FILENAME='shebang_unit'
_SOURCES_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_RELEASE_DIRECTORY="${_SOURCES_DIRECTORY}/../../releases"

_ORDERED_SOURCES=('header.sh' 'configuration.sh' 'system.sh' 'assertion.sh'
                  'parser.sh' 'runner.sh' 'main.sh')

function release::concatenate_sources_in_release_file() {
	release::_delete_release_file_if_existing
	release::_concatenate_sources_in_release_file
	release::_append_runner_call_in_release_file
	release::_make_release_file_executable
}

function release::_delete_release_file_if_existing() {
	echo "$(release::get_released_artifact_file)"
	if [[ -f "$(release::get_released_artifact_file)" ]]; then
		rm "$(release::get_released_artifact_file)"
	fi
}

function release::_concatenate_sources_in_release_file() {
	local file
	for file in "${_ORDERED_SOURCES[@]}"; do
		release::_append_file_to_release_file "${_SOURCES_DIRECTORY}/${file}"
	done
}

function release::_append_runner_call_in_release_file() {
	release::_append_to_release_file 'main::main $@'
}

function release::_append_file_to_release_file() {
	cat "$1" >> "$(release::get_released_artifact_file)"
	release::_append_to_release_file "\n\n"
}

function release::_make_release_file_executable() {
	chmod +x "$(release::get_released_artifact_file)"
}

function release::_append_to_release_file() {
  printf "$1" >> "$(release::get_released_artifact_file)"
}

function release::get_released_artifact_file() {
	printf "${_RELEASE_DIRECTORY}/${_RELEASED_ARTIFACT_FILENAME}"
}