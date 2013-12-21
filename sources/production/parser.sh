_GLOBAL_SETUP_FUNCTION_NAME="globalSetup"
_GLOBAL_TEARDOWN_FUNCTION_NAME="globalTeardown"
_SETUP_FUNCTION_NAME="setup"
_TEARDOWN_FUNCTION_NAME="teardown"

function file_parser::findGlobalSetupFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_GLOBAL_SETUP_FUNCTION_NAME}"
}

function file_parser::findGlobalTeardownFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function file_parser::findSetupFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_SETUP_FUNCTION_NAME}"
}

function file_parser::findTeardownFunctionInFile() {
	local file=$1
	_findFunctionsInFile "${file}" | grep "${_TEARDOWN_FUNCTION_NAME}"
}

function file_parser::findTestFunctionsInFile() {
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