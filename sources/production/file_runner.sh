function file_runner__run_test_file() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	local public_functions=($(parser__get_public_functions_in_file "${file}"))
	_file_runner__call_global_setup_if_exists "${public_functions[@]}"
	_file_runner__call_all_tests "${public_functions[@]}"
	_file_runner__call_global_teardown_if_exists "${public_functions[@]}"
	printf "\n"
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
		_file_runner__call_test_function_in_the_middle_of_setup_and_teardown \
			"${function}" "$@"
	fi
}

function _file_runner__function_is_a_test() {
	! system__array_contains "$1" \
	                    "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
	                    "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
	                    "${SBU_SETUP_FUNCTION_NAME}" \
	                    "${SBU_TEARDOWN_FUNCTION_NAME}"
}

function _file_runner__call_test_function_in_the_middle_of_setup_and_teardown() {
	local test_function=$1
	shift 1

	printf "[Test] ${test_function}\n"
	(
	  _file_runner__call_setup_if_exists "$@" \
	  && ( ${test_function} )
	  local setup_and_test_code=$?
	  _file_runner__call_teardown_if_exists "$@"
	  (( $? == ${SBU_SUCCESS_STATUS_CODE} \
	  &&  ${setup_and_test_code} == ${SBU_SUCCESS_STATUS_CODE} ))
	)
	_file_runner__parse_test_function_result $?
}

function _file_runner__call_setup_if_exists() {
  _file_runner__call_function_if_exits "${SBU_SETUP_FUNCTION_NAME}" "$@"
}

function _file_runner__call_teardown_if_exists() {
  _file_runner__call_function_if_exits "${SBU_TEARDOWN_FUNCTION_NAME}" "$@"
}

function _file_runner__parse_test_function_result() {
	if (( $1 == ${SBU_SUCCESS_STATUS_CODE} )); then
		(( global_green_tests_count++ ))
		_file_runner__print_with_color "OK" ${SBU_GREEN_COLOR_CODE}
	else
		(( global_red_tests_count++ ))
		_file_runner__print_with_color "KO" ${SBU_RED_COLOR_CODE}
	fi
}

function _file_runner__print_with_color() {
	system__print_with_color "$1" "$2" "${SBU_DEFAULT_COLOR_CODE}"
}

function _file_runner__call_function_if_exits() {
	local function=$1
	shift 1
	if system__array_contains "${function}" "$@"; then
	  "${function}"
	fi
}