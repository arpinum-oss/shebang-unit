parser__get_public_functions_in_file() {
  _parser__find_functions_in_file "$1" \
    | _parser__filter_private_functions \
    | awk '{ print $1 }'
}

_parser__find_functions_in_file() {
  grep -o "${SBU_FUNCTION_DECLARATION_REGEX}" "$1" \
    | _parser__get_function_name_from_declaration
}

_parser__filter_private_functions() {
  grep -v "${SBU_PRIVATE_FUNCTION_NAME_REGEX}"
}

_parser__get_function_name_from_declaration() {
  sed "s/${SBU_FUNCTION_DECLARATION_REGEX}/\2/"
}
