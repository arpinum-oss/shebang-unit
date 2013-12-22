function can_get_string_if_not_empty() {
	local result="$(system::get_string_or_default_if_empty "not empty" "default")"

	assertion::equal "not empty" "${result}"
}

function can_get_string_if_not_empty() {
	local result="$(system::get_string_or_default_if_empty "" "default")"

	assertion::equal "default" "${result}"
}

function the_date_in_seconds_is_a_valid_number() {
	local number="$(system::get_date_in_seconds)"

	_is_a_number ${number}

	assertion::status_code_is_success $? "The actual value <${number}> is not a number."
}

function _is_a_number() {
	[[ "${1}" =~ ^[0-9]+$ ]]
}

function can_print_with_color() {
	local message="$(system::print_with_color "text" "color" "default_color")"

	assertion::equal "colortextdefault_color" "${message}"
}

function a_contained_value_is_contained_by_the_array() {
	local array=("a" "b" "c")

	system::array_contains "b" "${array[@]}"

	assertion::status_code_is_success $? "The array does not contain the value."
}

function a_not_contained_value_is_not_contained_by_the_array() {
	local array=("a" "b" "c")

	system::array_contains "z" "${array[@]}"

	assertion::status_code_is_failure $? "The array contain the value."
}

function can_print_array() {
	local array=("a" "123" "douze")

	local string="$(system::print_array "${array[@]}")"

	assertion::equal "[a, 123, douze]" "${string}"
}

function can_print_array_with_spaces() {
	local array=("un deux" "54" "choco lat")

	local string="$(system::print_array "${array[@]}")"

	assertion::equal "[un deux, 54, choco lat]" "${string}"
}