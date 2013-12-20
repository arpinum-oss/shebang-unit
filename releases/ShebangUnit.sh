# Shebang unit all in one source file

#Beginning of assertion.sh
function assertEqual() {
	local expected=$1; local actual=$2
	if [[ "${expected}" != "${actual}" ]]; then
		_assertionFailed "Actual : <${actual}>, expected : <${expected}>."
	fi
}

function assertStringContains() {
	local container=$1; local contained=$2
	if ! _stringContains "${container}" "${contained}"; then
		_assertionFailed "String: <${container}> does not contain: <${contained}>."
	fi
}

function assertStringDoesNotContain() {
	local container=$1; local contained=$2
	if _stringContains "${container}" "${contained}"; then
		_assertionFailed "String: <${container}> contains: <${contained}>."
	fi
}

function _stringContains() {
	local container=$1; local contained=$2
	[[ "${container}" == *"${contained}"* ]]
}

function assertStatusCodeIsSuccess() {
	local statusCode=$1; local customMessage=$2
	if (( ${statusCode} != ${SUCCESS_STATUS_CODE} )); then
		_assertionFailed "Status code is failure instead of success." "${customMessage}"
	fi
}

function assertStatusCodeIsFailure() {
	local statusCode=$1; local customMessage=$2
	if (( ${statusCode} == ${SUCCESS_STATUS_CODE} )); then
		_assertionFailed "Status code is success instead of failure." "${customMessage}"
	fi
}

function _assertionFailed() {
	local message=$1; local customMessage=$2
	local messageToUse="$(_getAssertionMessageToUse "${message}" "${customMessage}")"
	printf "Assertion failed. ${messageToUse}\n"
	exit ${FAILURE_STATUS_CODE}
}

function _getAssertionMessageToUse() {
	local message=$1; local customMesssage=$2
	if [[ -n "${customMesssage}" ]]; then
		printf "%s %s\n" "${message}" "${customMesssage}"
	else
		printf "${message}\n"
	fi
}
#End of assertion.sh

#Beginning of fileParser.sh
_GLOBAL_SETUP_FUNCTION_NAME="globalSetup"
_GLOBAL_TEARDOWN_FUNCTION_NAME="globalTeardown"
_SETUP_FUNCTION_NAME="setup"
_TEARDOWN_FUNCTION_NAME="teardown"

function fileParser_findGlobalSetupFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_GLOBAL_SETUP_FUNCTION_NAME}"
}

function fileParser_findGlobalTeardownFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function fileParser_findSetupFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_SETUP_FUNCTION_NAME}"
}

function fileParser_findTeardownFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_TEARDOWN_FUNCTION_NAME}"
}

function fileParser_findTestFunctionsInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | _filterPrivateFunctions | _filterSpecialFunctions
}

function _findFunctionsInFile() {
	local file=$1
	grep -o "^function.*()" "${file}" | _getFunctionNameFromDeclaration | tr -d " "
}

function _filterPrivateFunctions() {
	grep -v "^_.*"
}

function _filterSpecialFunctions() {
	grep -v "${_SETUP_FUNCTION_NAME}\|${_TEARDOWN_FUNCTION_NAME}\|${_GLOBAL_SETUP_FUNCTION_NAME}\|${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function _getFunctionNameFromDeclaration() {
	sed "s/function\(.*\)()/\1/"
}
#End of fileParser.sh

#Beginning of runner.sh
_GREEN_COLOR_CODE="\\033[1;32m"
_RED_COLOR_CODE="\\033[1;31m"
_DEFAULT_COLOR_CODE="\\e[0m"

_DEFAULT_TEST_FILE_PATTERN=*Test.sh

function runner_runAllTestFilesInDirectory() {
	local directory=$1; local overridenTestFilePattern=$2

	_initialiseTestsExecution
	local testFilePattern="$(system_getStringOfDefaultIfEmpty "${overridenTestFilePattern}" "${_DEFAULT_TEST_FILE_PATTERN}")"
	_runAllTestfilesWithPatternInDirectory "${testFilePattern}" "${directory}"
	_printTestsResults
	_testsAreSuccessful
}

function _initialiseTestsExecution() {
	_GREEN_TESTS_COUNT=0
	_RED_TESTS_COUNT=0
	_EXECUTION_BEGINING_DATE="$(system_getDateInSeconds)"
}

function _runAllTestfilesWithPatternInDirectory() {
	local testFilePattern=$1; local directory=$2

	local file; for file in $(find "${directory}" -name ${testFilePattern}); do
		_runTestFile "${file}"
	done
}

function _runTestFile() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	_callGlobalSetupInFile "${file}"
	_callAllTestsInFile "${file}"
	_callGlobalTeardownInFile "${file}"
	printf "\n"
}

function _callGlobalSetupInFile() {
	local file=$1
	_callFunctionIfExisting "$(fileParser_findGlobalSetupFunctionInFile "${file}")"
}

function _callGlobalTeardownInFile() {
	local file=$1
	_callFunctionIfExisting "$(fileParser_findGlobalTeardownFunctionInFile "${file}")"
}

function _callAllTestsInFile() {
	local file=$1
	local testFunction; for testFunction in $(fileParser_findTestFunctionsInFile "${file}"); do
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
	_callFunctionIfExisting "$(fileParser_findSetupFunctionInFile "${file}")"
}

function _callTeardownInFile() {
	local file=$1
	_callFunctionIfExisting "$(fileParser_findTeardownFunctionInFile "${file}")"
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
	local endingDate="$(system_getDateInSeconds)"
	printf "$((${endingDate} - ${_EXECUTION_BEGINING_DATE}))"
}

function _printWithColor() {
	local text=$1; local colorCode=$2
	system_printWithColor "${text}" "${colorCode}" "${_DEFAULT_COLOR_CODE}"
}

function _testsAreSuccessful() {
	(( ${_RED_TESTS_COUNT} == 0 ))
}

function _callFunctionIfExisting() {
	local function=$1
	if [[ -n "${function}" ]]; then
		eval ${function}
	fi
}
#End of runner.sh

#Beginning of system.sh
SUCCESS_STATUS_CODE=0
FAILURE_STATUS_CODE=1

function system_getStringOfDefaultIfEmpty() {
	local string=$1; local defaultString=$2
	local result=${string}
	if [[ -z "${string}" ]]; then
		result="${defaultString}"
	fi
	printf "${result}"
}

function system_getDateInSeconds() {
	date +%s
}

function system_printWithColor() {
	local text=$1; local color=$2; local defaultColor=$3
	printf "${color}${text}${defaultColor}\n"
}
#End of system.sh
