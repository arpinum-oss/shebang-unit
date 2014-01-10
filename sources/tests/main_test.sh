_SOURCE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_PRODUCTION_DIRECTORY="${_SOURCE_DIRECTORY}/../production"
_TEST_DIRECTORY="${_SOURCE_DIRECTORY}/../../resources/tests/\
directory_with_no_test"

function global_setup() {
	source "${_PRODUCTION_DIRECTORY}/main.sh"
}

function can_enable_colors() {
	SBU_USE_COLORS="${SBU_NO}"

	main::main --colors="${SBU_YES}" "${_TEST_DIRECTORY}" > /dev/null

	assertion::equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

function can_enable_colors_with_short_argument() {
	SBU_USE_COLORS="${SBU_NO}"

	main::main -c="${SBU_YES}" "${_TEST_DIRECTORY}" > /dev/null

	assertion::equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

function can_disable_colors() {
	SBU_USE_COLORS="${SBU_YES}"

	main::main --colors="${SBU_NO}" "${_TEST_DIRECTORY}" > /dev/null

	assertion::equal "${SBU_NO}" "${SBU_USE_COLORS}"
}

function can_use_a_test_file_pattern() {
	SBU_TEST_FILE_PATTERN="anything"

	main::main --pattern=*my_test.sh "${_TEST_DIRECTORY}" > /dev/null

	assertion::equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

function can_use_a_test_file_pattern_with_short_argument() {
	SBU_TEST_FILE_PATTERN="anything"

	main::main -p=*my_test.sh "${_TEST_DIRECTORY}" > /dev/null

	assertion::equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}