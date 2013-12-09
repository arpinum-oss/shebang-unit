[[ "${SOURCE_RUNNER}" != "" ]] && return || readonly SOURCE_RUNNER=1

source ${0%/*}/../production/system.sh
source ${0%/*}/../production/fileParser.sh
source ${0%/*}/../production/assertion.sh

_GREEN_COLOR_CODE="\\033[1;32m"
_RED_COLOR_CODE="\\033[1;31m"
_DEFAULT_COLOR_CODE="\\e[0m"

_DEFAULT_TEST_FILE_PATTERN=*Test.sh

function runner_runAllTestFilesInDirectory() {
	local directory=${1}; local overridenTestFilePattern=${2}

	_initialiseTestsExecution
	local testFilePattern=$(system_getStringOfDefaultIfEmpty "${overridenTestFilePattern}" "${_DEFAULT_TEST_FILE_PATTERN}")
	_runAllTestfilesWithPatternInDirectory "${testFilePattern}" "${directory}"
	_printTestsResults
	_testsAreSuccessful
}

function _initialiseTestsExecution() {
	_GREEN_TESTS_COUNT=0
	_RED_TESTS_COUNT=0
	_EXECUTION_BEGINING_DATE=$(system_getDateInSeconds)
}

function _runAllTestfilesWithPatternInDirectory() {
	local testFilePattern=${1}; local directory=${2}

	local file; for file in $(find "${directory}" -name ${testFilePattern}); do
		_runTestFile "${file}"
	done
}

function _runTestFile() {
	local file=${1}
	printf "[File] ${file}\n"
	source "${file}"
	_callGlobalSetupInFile "${file}"
	_callAllTestsInFile "${file}"
	_callGlobalTeardownInFile "${file}"
	printf "\n"
}

function _callGlobalSetupInFile() {
	local file=${1}
	_callFunctionIfExisting $(fileParser_findGlobalSetupFunctionInFile "${file}")
}

function _callGlobalTeardownInFile() {
	local file=${1}
	_callFunctionIfExisting $(fileParser_findGlobalTeardownFunctionInFile "${file}")
}

function _callAllTestsInFile() {
	local file=${1}
	local testFunction; for testFunction in $(fileParser_findTestFunctionsInFile "${file}"); do
		_callTestFunctionInTheMiddleOfSetupAndTeardown "${testFunction}" "${file}"
	done
}

function _callTestFunctionInTheMiddleOfSetupAndTeardown() {
	local testFunction=${1}; local file=${2}

	printf "[Test] ${testFunction}\n"
	( _callSetupInFile "${file}" &&
	( ${testFunction} ) &&
	_callTeardownInFile "${file}" )
	_parseTestFunctionResult "${testFunction}" ${?}
}

function _callSetupInFile() {
	local file=${1}
	_callFunctionIfExisting $(fileParser_findSetupFunctionInFile "${file}")
}

function _callTeardownInFile() {
	local file=${1}
	_callFunctionIfExisting $(fileParser_findTeardownFunctionInFile "${file}")
}

function _parseTestFunctionResult() {
	local testFunction=${1}; local statusCode=${2}

	if (( ${statusCode} == ${SUCCESS_STATUS_CODE} )); then
		(( _GREEN_TESTS_COUNT++ ))
		_printWithColor "OK" ${_GREEN_COLOR_CODE}
	else
		(( _RED_TESTS_COUNT++ ))
		_printWithColor "KO" ${_RED_COLOR_CODE}
	fi
}

function _printTestsResults() {
	local color=$(_getColorCodeForTestsResult)
	local executionTime=$(_getExecutionTime)
	printf "[Results]\n"
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
	local endingDate=$(system_getDateInSeconds)
	printf $((${endingDate} - ${_EXECUTION_BEGINING_DATE}))
}

function _printWithColor() {
	local text=${1}; local colorCode=${2}
	system_printWithColor "${text}" "${colorCode}" "${_DEFAULT_COLOR_CODE}"
}

function _testsAreSuccessful() {
	(( ${_RED_TESTS_COUNT} == 0 ))
}

function _callFunctionIfExisting() {
	local function=${1}
	if [[ "${function}" != "" ]]; then
		eval ${function}
	fi
}