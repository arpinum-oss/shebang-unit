# Shebang unit all in one source file

#Beginning of assertion.sh
function assertion::equal() {
	local expected=$1; local actual=$2
	if [[ "${expected}" != "${actual}" ]]; then
		_assertion_failed "Actual : <${actual}>, expected : <${expected}>."
	fi
}

function assertion::string_contains() {
	local container=$1; local contained=$2
	if ! _string_contains "${container}" "${contained}"; then
		_assertion_failed "String: <${container}> does not contain: <${contained}>."
	fi
}

function assertion::string_does_not_contain() {
	local container=$1; local contained=$2
	if _string_contains "${container}" "${contained}"; then
		_assertion_failed "String: <${container}> contains: <${contained}>."
	fi
}

function _string_contains() {
	local container=$1; local contained=$2
	[[ "${container}" == *"${contained}"* ]]
}

function assertion::status_code_is_success() {
	local status_code=$1; local custom_message=$2
	if (( ${status_code} != ${SUCCESS_STATUS_CODE} )); then
		_assertion_failed "Status code is failure instead of success." "${custom_message}"
	fi
}

function assertion::status_code_is_failure() {
	local status_code=$1; local custom_message=$2
	if (( ${status_code} == ${SUCCESS_STATUS_CODE} )); then
		_assertion_failed "Status code is success instead of failure." "${custom_message}"
	fi
}

function _assertion_failed() {
	local message=$1; local custom_message=$2
	local message_to_use="$(_get_assertion_message_to_use "${message}" "${custom_message}")"
	printf "Assertion failed. ${message_to_use}\n"
	exit ${FAILURE_STATUS_CODE}
}

function _get_assertion_message_to_use() {
	local message=$1; local custom_messsage=$2
	if [[ -n "${custom_messsage}" ]]; then
		printf "%s %s\n" "${message}" "${custom_messsage}"
	else
		printf "${message}\n"
	fi
}
#End of assertion.sh

#Beginning of parser.sh
_GLOBAL_SETUP_FUNCTION_NAME="globalSetup"
_GLOBAL_TEARDOWN_FUNCTION_NAME="globalTeardown"
_SETUP_FUNCTION_NAME="setup"
_TEARDOWN_FUNCTION_NAME="teardown"

function file_parser::find_global_setup_function_in_file() {
	local file=$1
	_find_functions_in_file "${file}" | grep "${_GLOBAL_SETUP_FUNCTION_NAME}"
}

function file_parser::find_global_teardown_function_in_file() {
	local file=$1
	_find_functions_in_file "${file}" | grep "${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function file_parser::find_setup_function_in_file() {
	local file=$1
	_find_functions_in_file "${file}" | grep "${_SETUP_FUNCTION_NAME}"
}

function file_parser::find_teardown_function_in_file() {
	local file=$1
	_find_functions_in_file "${file}" | grep "${_TEARDOWN_FUNCTION_NAME}"
}

function file_parser::find_test_functions_in_file() {
	local file=$1
	_find_functions_in_file "${file}" | _filter_private_functions | _filter_special_functions
}

function _find_functions_in_file() {
	local file=$1
	grep -o "^function.*()" "${file}" | _get_function_name_from_declaration | tr -d " "
}

function _filter_private_functions() {
	grep -v "^_.*"
}

function _filter_special_functions() {
	grep -v "${_SETUP_FUNCTION_NAME}\|${_TEARDOWN_FUNCTION_NAME}\|${_GLOBAL_SETUP_FUNCTION_NAME}\|${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function _get_function_name_from_declaration() {
	sed "s/function\(.*\)()/\1/"
}
#End of parser.sh

#Beginning of runner.sh
_GREEN_COLOR_CODE="\\033[1;32m"
_RED_COLOR_CODE="\\033[1;31m"
_DEFAULT_COLOR_CODE="\\e[0m"

_DEFAULT_TEST_FILE_PATTERN=*_test.sh

function runner::run_all_test_files_in_directory() {
	local directory=$1; local overriden_test_file_pattern=$2

	runner::_initialise_tests_execution
	local testFilePattern="$(system::get_string_or_default_if_empty "${overriden_test_file_pattern}" "${_DEFAULT_TEST_FILE_PATTERN}")"
	_run_all_test_files_with_pattern_in_directory "${testFilePattern}" "${directory}"
	_printTestsResults
	_testsAreSuccessful
}

function runner::_initialise_tests_execution() {
	_GREEN_TESTS_COUNT=0
	_RED_TESTS_COUNT=0
	_EXECUTION_BEGINING_DATE="$(system::get_date_in_seconds)"
}

function _run_all_test_files_with_pattern_in_directory() {
	local test_file_pattern=$1; local directory=$2

	local file; for file in $(find "${directory}" -name ${test_file_pattern}); do
		_run_test_file "${file}"
	done
}

function _run_test_file() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	_call_global_setup_in_file "${file}"
	_call_all_tests_in_file "${file}"
	_call_global_teardown_in_file "${file}"
	printf "\n"
}

function _call_global_setup_in_file() {
	local file=$1
	_call_function_if_existing "$(file_parser::find_global_setup_function_in_file "${file}")"
}

function _call_global_teardown_in_file() {
	local file=$1
	_call_function_if_existing "$(file_parser::find_global_teardown_function_in_file "${file}")"
}

function _call_all_tests_in_file() {
	local file=$1
	local testFunction; for testFunction in $(file_parser::find_test_functions_in_file "${file}"); do
		_callTestFunctionInTheMiddleOfSetupAndTeardown "${testFunction}" "${file}"
	done
}

function _callTestFunctionInTheMiddleOfSetupAndTeardown() {
	local testFunction=$1; local file=$2

	printf "[Test] ${testFunction}\n"
	( _callSetupInFile "${file}" &&
	( ${testFunction} ) &&
	_callTeardownInFile "${file}" )
	_parseTestFunctionResult "${testFunction}" $?
}

function _callSetupInFile() {
	local file=$1
	_call_function_if_existing "$(file_parser::find_setup_function_in_file "${file}")"
}

function _callTeardownInFile() {
	local file=$1
	_call_function_if_existing "$(file_parser::find_teardown_function_in_file "${file}")"
}

function _parseTestFunctionResult() {
	local testFunction=$1; local statusCode=$2

	if (( ${statusCode} == ${SUCCESS_STATUS_CODE} )); then
		(( _GREEN_TESTS_COUNT++ ))
		_printWithColor "OK" ${_GREEN_COLOR_CODE}
	else
		(( _RED_TESTS_COUNT++ ))
		_printWithColor "KO" ${_RED_COLOR_CODE}
	fi
}

function _printTestsResults() {
	printf "[Results]\n"
	local color="$(_getColorCodeForTestsResult)"
	local executionTime="$(_getExecutionTime)"
	_printWithColor "Green tests : ${_GREEN_TESTS_COUNT}, red : ${_RED_TESTS_COUNT} in ${executionTime}s" "${color}"
}

function _getColorCodeForTestsResult() {
	local colorCode=${_GREEN_COLOR_CODE}
	if ! _testsAreSuccessful; then
		colorCode=${_RED_COLOR_CODE}
	fi
	printf "${colorCode}"
}

function _getExecutionTime() {
	local endingDate="$(system::get_date_in_seconds)"
	printf "$((${endingDate} - ${_EXECUTION_BEGINING_DATE}))"
}

function _printWithColor() {
	local text=$1; local colorCode=$2
	system::printWithColor "${text}" "${colorCode}" "${_DEFAULT_COLOR_CODE}"
}

function _testsAreSuccessful() {
	(( ${_RED_TESTS_COUNT} == 0 ))
}

function _call_function_if_existing() {
	local function=$1
	if [[ -n "${function}" ]]; then
		eval ${function}
	fi
}
#End of runner.sh

#Beginning of system.sh
SUCCESS_STATUS_CODE=0
FAILURE_STATUS_CODE=1

function system::get_string_or_default_if_empty() {
	local string=$1; local default_string=$2
	local result=${string}
	if [[ -z "${string}" ]]; then
		result="${default_string}"
	fi
	printf "${result}"
}

function system::get_date_in_seconds() {
	date +%s
}

function system::printWithColor() {
	local text=$1; local color=$2; local defaultColor=$3
	printf "${color}${text}${defaultColor}\n"
}
#End of system.sh
