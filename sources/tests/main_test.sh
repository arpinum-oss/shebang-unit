_PRODUCTION_SOURCES_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")/../production"

_TEST_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")/../../resources/tests/directory_with_no_test"

function global_setup() {
	source "${_PRODUCTION_SOURCES_DIRECTORY}/main.sh"
}

function can_enable_colors() {
	SBU_USE_COLORS="no"

	main::main --colors=yes "${_TEST_DIRECTORY}"

	assertion::equal "yes" "${SBU_USE_COLORS}"
}

function can_enable_colors_with_short_argument() {
	SBU_USE_COLORS="no"

	main::main -c=yes "${_TEST_DIRECTORY}"

	assertion::equal "yes" "${SBU_USE_COLORS}"
}

function can_disable_colors() {
	SBU_USE_COLORS="yes"

	main::main --colors=no "${_TEST_DIRECTORY}"

	assertion::equal "no" "${SBU_USE_COLORS}"
}

function can_use_a_test_file_pattern() {
	SBU_TEST_FILE_PATTERN="anything"

	main::main --pattern=*my_test.sh "${_TEST_DIRECTORY}"

	assertion::equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

function can_use_a_test_file_pattern_with_short_argument() {
	SBU_TEST_FILE_PATTERN="anything"

	main::main -p=*my_test.sh "${_TEST_DIRECTORY}"

	assertion::equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}