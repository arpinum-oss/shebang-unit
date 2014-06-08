function file_runner__run_test_file() {
	local file=$1
	reporter__test_file_starts_running "${file}"
	source "${file}"
	local public_functions=($(parser__get_public_functions_in_file "${file}"))
	_file_runner__run_global_setup_if_exists "${public_functions[@]}"
	_file_runner__run_all_tests_if_global_setup_is_successful \
	  $? "${public_functions[@]}"
	_file_runner__run_global_teardown_if_exists "${public_functions[@]}"
	reporter__test_file_ends_running
}

function _file_runner__run_all_tests_if_global_setup_is_successful() {
  local global_setup_status_code=$1
  shift 1
	if (( ${global_setup_status_code} == ${SBU_SUCCESS_STATUS_CODE} )); then
	  _file_runner__call_all_tests "$@"
	else
	  reporter__global_setup_has_failed
	  _file_runner__skip_all_tests "$@"
	fi
}

function _file_runner__call_all_tests() {
	local i
	for (( i=1; i <= $#; i++ )); do
	  local function=${!i}
		if _file_runner__function_is_a_test "${function}"; then
		  test_runner__run_test "${function}" "$@"
		fi
	done
}

function _file_runner__skip_all_tests() {
	local i
	for (( i=1; i <= $#; i++ )); do
	  local function=${!i}
	  if _file_runner__function_is_a_test "${function}"; then
		  test_runner__skip_test "${function}"
		fi
	done
}

function _file_runner__run_global_setup_if_exists() {
  _file_runner__call_function_if_exits "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
    "$@"
}

function _file_runner__run_global_teardown_if_exists() {
  _file_runner__call_function_if_exits "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
    "$@"
}

function _file_runner__function_is_a_test() {
	! system__array_contains "$1" \
	                    "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
	                    "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
	                    "${SBU_SETUP_FUNCTION_NAME}" \
	                    "${SBU_TEARDOWN_FUNCTION_NAME}"
}

function _file_runner__call_function_if_exits() {
	local function=$1
	shift 1
	if system__array_contains "${function}" "$@"; then
	  "${function}"
	fi
}