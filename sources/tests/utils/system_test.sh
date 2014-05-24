function can_get_string_if_not_empty() {
	local result="$(system__get_string_or_default "not empty" "default")"

	assertion__equal "not empty" "${result}"
}

function can_get_string_if_not_empty() {
	local result="$(system__get_string_or_default "" "default")"

	assertion__equal "default" "${result}"
}

function the_date_in_seconds_is_a_valid_number() {
	local number="$(system__get_date_in_seconds)"

	assertion__successful _is_a_number ${number}
}

function _is_a_number() {
	[[ "$1" =~ ^[0-9]+$ ]]
}

function can_print_with_color() {
	SBU_USE_COLORS="${SBU_YES}"
	SBU_DEFAULT_COLOR_CODE="default_color"

	local message="$(system__print_with_color "text" "color")"

	assertion__equal "colortextdefault_color" "${message}"
}

function can_print_line_with_color() {
	SBU_USE_COLORS="${SBU_YES}"
	SBU_DEFAULT_COLOR_CODE="default_color"

	local message="$(system__print_line_with_color "text" "color")"

  # impossible to test the trailing \n which is trimmed when $(...)
	assertion__equal "colortextdefault_color" "${message}"
}

function can_print_without_color_if_colors_are_turned_off() {
	SBU_USE_COLORS="${SBU_NO}"

	local message="$(system__print_with_color "text" "color")"

	assertion__equal "text" "${message}"
}

function a_contained_value_is_contained_by_the_array() {
	local array=("a" "the element" "c")

	assertion__successful system__array_contains "the element" "${array[@]}"
}

function a_not_contained_value_is_not_contained_by_the_array() {
	local array=("a" "the element" "c")

	assertion__failing system__array_contains "the" "${array[@]}"
}

function can_print_array() {
	local array=("a" "123" "douze")

	local string="$(system__print_array "${array[@]}")"

	assertion__equal "[a, 123, douze]" "${string}"
}

function can_print_array_with_spaces() {
	local array=("un deux" "54" "choco lat")

	local string="$(system__print_array "${array[@]}")"

	assertion__equal "[un deux, 54, choco lat]" "${string}"
}

function a_substring_is_contained_by_the_string() {
	assertion__successful system__string_contains "the string" "the st"
}

function a_totally_different_string_is_not_contained_by_the_string() {
	assertion__failing system__string_contains "the string" "plop"
}