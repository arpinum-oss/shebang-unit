function parser::get_public_functions_in_file() {
	parser::_find_functions_in_file "$1" \
	  | parser::_filter_private_functions \
	  | awk '{ print $1 }'
}

function parser::_find_functions_in_file() {
	grep -o "${SBU_FUNCTION_DECLARATION_REGEX}" "$1" \
		| parser::_get_function_name_from_declaration
}

function parser::_filter_private_functions() {
	grep -v "${SBU_PRIVATE_FUNCTION_NAME_REGEX}"
}

function parser::_get_function_name_from_declaration() {
	sed "s/${SBU_FUNCTION_DECLARATION_REGEX}/\1/"
}