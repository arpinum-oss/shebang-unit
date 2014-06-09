function file_runner__run_test_file() {
	local file=$1
	local public_functions=($(parser__get_public_functions_in_file "${file}"))
  local test_functions=($(_file_runner__get_test_functions))
	reporter__test_file_starts_running "${file}" "${#test_functions[@]}"
	source "${file}"
	_file_runner__run_global_setup_if_exists
	_file_runner__run_all_tests_if_global_setup_is_successful $?
	_file_runner__run_global_teardown_if_exists
	reporter__test_file_ends_running
}

function _file_runner__run_all_tests_if_global_setup_is_successful() {
  local global_setup_status_code=$1
	if (( ${global_setup_status_code} == ${SBU_SUCCESS_STATUS_CODE} )); then
	  _file_runner__call_all_tests
	else
	  reporter__global_setup_has_failed
	  _file_runner__skip_all_tests
	fi
}

function _file_runner__call_all_tests() {
	local i
	for (( i=0; i < ${#test_functions[@]}; i++ )); do
    test_runner__run_test "${test_functions[${i}]}" "${public_functions[@]}"
	done
}

function _file_runner__skip_all_tests() {
	local i
	for (( i=0; i < ${#test_functions[@]}; i++ )); do
    test_runner__skip_test "${test_functions[${i}]}" "${public_functions[@]}"
	done
}

function _file_runner__get_test_functions() {
	local i
	for (( i=0; i < "${#public_functions[@]}"; i++ )); do
	  local function="${public_functions[${i}]}"
	  if _file_runner__function_is_a_test "${function}"; then
		  system__print_line "${function}"
		fi
	done
}

function _file_runner__run_global_setup_if_exists() {
  _file_runner__call_function_if_exits "${SBU_GLOBAL_SETUP_FUNCTION_NAME}"
}

function _file_runner__run_global_teardown_if_exists() {
  _file_runner__call_function_if_exits "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}"
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
	if system__array_contains "${function}" "${public_functions[@]}"; then
	  "${function}"
	fi
}