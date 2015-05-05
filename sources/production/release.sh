_RELEASED_ARTIFACT_FILENAME='shebang-unit'
_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
_SOURCES_DIR="${_ROOT_DIR}/sources/production"
_RELEASE_DIR="${_ROOT_DIR}/releases"
_ORDERED_MODULES_FILE="${_ROOT_DIR}/resources/production/ordered_modules.txt"

release__concatenate_sources_in_release_file() {
  _release__initialise
  _release__concatenate_sources_in_release_file
  _release__append_runner_call_in_release_file
  _release__make_release_file_executable
}

_release__initialise() {
  _release__delete_release_file_if_existing
  mkdir -p "${_RELEASE_DIR}"
}

_release__delete_release_file_if_existing() {
  if [[ -f "$(release__get_released_artifact_file)" ]]; then
    rm "$(release__get_released_artifact_file)"
  fi
}

_release__concatenate_sources_in_release_file() {
  release__execute_for_each_module _release__append_module_to_release_file
}

release__execute_for_each_module() {
  local module_path
  while read module_path; do
    "$@"
  done < "${_ORDERED_MODULES_FILE}"
}

_release__append_runner_call_in_release_file() {
  _release__append_to_release_file 'main__main "$@"'
}

_release__append_module_to_release_file() {
  _release__append_file_to_release_file "${_SOURCES_DIR}/${module_path}.sh"
}

_release__append_file_to_release_file() {
  cat "$1" >> "$(release__get_released_artifact_file)"
  _release__append_to_release_file "\n\n"
}

_release__make_release_file_executable() {
  chmod +x "$(release__get_released_artifact_file)"
}

_release__append_to_release_file() {
  printf "$1" >> "$(release__get_released_artifact_file)"
}

release__get_released_artifact_file() {
  printf "${_RELEASE_DIR}/${_RELEASED_ARTIFACT_FILENAME}"
}
