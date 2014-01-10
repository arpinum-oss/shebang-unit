function can_get_string_if_not_empty() {
	local result="$(system::get_string_or_default "not empty" "default")"

	assertion::equal "not empty" "${result}"
}

function can_get_string_if_not_empty() {
	local result="$(system::get_string_or_default "" "default")"

	assertion::equal "default" "${result}"
}

function the_date_in_seconds_is_a_valid_number() {
	local number="$(system::get_date_in_seconds)"

	assertion::successful _is_a_number ${number}
}

function _is_a_number() {
	[[ "${1}" =~ ^[0-9]+$ ]]
}

function can_print_with_color() {
	SBU_USE_COLORS="${SBU_YES}"

	local message="$(system::print_with_color "text" "color" "default_color")"

	assertion::equal "colortextdefault_color" "${message}"
}

function can_print_without_color_if_colors_are_turned_off() {
	SBU_USE_COLORS="${SBU_NO}"

	local message="$(system::print_with_color "text" "color" "default_color")"

	assertion::equal "text" "${message}"
}

function a_contained_value_is_contained_by_the_array() {
	local array=("a" "the element" "c")

	assertion::successful system::array_contains "the element" "${array[@]}"
}

function a_not_contained_value_is_not_contained_by_the_array() {
	local array=("a" "the element" "c")

	assertion::failing system::array_contains "the" "${array[@]}"
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

function a_substring_is_contained_by_the_string() {
	assertion::successful system::string_contains "the string" "the st"
}

function a_totally_different_string_is_not_contained_by_the_string() {
	assertion::failing system::string_contains "the string" "plop"
}