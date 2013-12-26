function parser::get_public_functions_in_file() {
	local functions=()
	parser::_find_functions_in_file "$1" | parser::_filter_private_functions | {
		local name; while read name; do
			printf "${name} "
		done
	}
}

function parser::_find_functions_in_file() {
	grep -o "^function.*()" "$1" | parser::_get_function_name_from_declaration | tr -d " "
}

function parser::_filter_private_functions() {
	grep -v "^_.*"
}

function parser::_get_function_name_from_declaration() {
	sed "s/function\(.*\)()/\1/"
}