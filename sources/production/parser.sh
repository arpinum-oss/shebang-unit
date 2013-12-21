function parser::find_global_setup_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${SBU_GLOBAL_SETUP_FUNCTION_NAME}"
}

function parser::find_global_teardown_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function parser::find_setup_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${SBU_SETUP_FUNCTION_NAME}"
}

function parser::find_teardown_function_in_file() {
	local file=$1
	parser::_find_functions_in_file "${file}" | grep "${SBU_TEARDOWN_FUNCTION_NAME}"
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
	grep -v "${SBU_SETUP_FUNCTION_NAME}\|${SBU_TEARDOWN_FUNCTION_NAME}\|${SBU_GLOBAL_SETUP_FUNCTION_NAME}\|${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

function parser::_get_function_name_from_declaration() {
	sed "s/function\(.*\)()/\1/"
}