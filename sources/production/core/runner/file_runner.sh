function file_runner__run_test_file() {
	local file=$1
	reporter__test_file_starts_running "${file}"
	source "${file}"
	local public_functions=($(parser__get_public_functions_in_file "${file}"))
	_file_runner__call_global_setup_if_exists "${public_functions[@]}"
	_file_runner__call_all_tests "${public_functions[@]}"
	_file_runner__call_global_teardown_if_exists "${public_functions[@]}"
	reporter__test_file_ends_running
}

function _file_runner__call_global_setup_if_exists() {
  _file_runner__call_function_if_exits "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
    "$@"
}

function _file_runner__call_global_teardown_if_exists() {
  _file_runner__call_function_if_exits "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
    "$@"
}

function _file_runner__call_all_tests() {
	local i
	for (( i=1; i <= $#; i++ )); do
		_file_runner__call_if_test_function "${!i}" "$@"
	done
}

function _file_runner__call_if_test_function() {
	local function=$1
	shift 1
	if _file_runner__function_is_a_test "${function}"; then
		test_runner__run_test "${function}" "$@"
	fi
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