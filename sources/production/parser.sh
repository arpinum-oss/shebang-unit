_GLOBAL_SETUP_FUNCTION_NAME="globalSetup"
_GLOBAL_TEARDOWN_FUNCTION_NAME="globalTeardown"
_SETUP_FUNCTION_NAME="setup"
_TEARDOWN_FUNCTION_NAME="teardown"

function parser::find_global_setup_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${_GLOBAL_SETUP_FUNCTION_NAME}"
}

function parser::find_global_teardown_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function parser::find_setup_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${_SETUP_FUNCTION_NAME}"
}

function parser::find_teardown_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${_TEARDOWN_FUNCTION_NAME}"
}

function parser::find_test_functions_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | parser::_filter_private_functions | parser::_filter_special_functions
}

function parser::_find_functions_in_file() {
	local file=$1
	grep -o "^function.*()" "${file}" | parser::_get_function_name_from_declaration | tr -d " "
}

function parser::_filter_private_functions() {
	grep -v "^_.*"
}

function parser::_filter_special_functions() {
	grep -v "${_SETUP_FUNCTION_NAME}\|${_TEARDOWN_FUNCTION_NAME}\|${_GLOBAL_SETUP_FUNCTION_NAME}\|${_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function parser::_get_function_name_from_declaration() {
	sed "s/function\(.*\)()/\1/"
}