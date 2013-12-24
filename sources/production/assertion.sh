function assertion::equal() {
	local expected=$1
	local actual=$2
	if [[ "${expected}" != "${actual}" ]]; then
		assertion::_assertion_failed "Actual: <${actual}>, expected: <${expected}>."
	fi
}

function assertion::string_contains() {
	local container=$1
	local contained=$2
	if ! system::string_contains "${container}" "${contained}"; then
		assertion::_assertion_failed "String: <${container}> does not contain: <${contained}>."
	fi
}

function assertion::string_does_not_contain() {
	local container=$1
	local contained=$2
	if system::string_contains "${container}" "${contained}"; then
		assertion::_assertion_failed "String: <${container}> contains: <${contained}>."
	fi
}

function assertion::array_contains() {
	local element=$1
	local array=("${@:2}")
	if ! system::array_contains "${element}" "${array[@]}"; then
		local array_as_string="$(system::print_array "${array[@]}")"
		assertion::_assertion_failed "Array: <${array_as_string}> does not contain: <${element}>."
	fi
}

function assertion::array_does_not_contains() {
	local element=$1
	local array=("${@:2}")
	if system::array_contains "${element}" "${array[@]}"; then
		local array_as_string="$(system::print_array "${array[@]}")"
		assertion::_assertion_failed "Array: <${array_as_string}> contains: <${element}>."
	fi
}

function assertion::status_code_is_success() {
	local status_code=$1
	local custom_message=$2
	if (( ${status_code} != ${SBU_SUCCESS_STATUS_CODE} )); then
		assertion::_assertion_failed "Status code is failure instead of success." "${custom_message}"
	fi
}

function assertion::status_code_is_failure() {
	local status_code=$1
	local custom_message=$2
	if (( ${status_code} == ${SBU_SUCCESS_STATUS_CODE} )); then
		assertion::_assertion_failed "Status code is success instead of failure." "${custom_message}"
	fi
}

function assertion::_assertion_failed() {
	local message=$1
	local custom_message=$2
	local message_to_use="$(assertion::_get_assertion_message_to_use "${message}" "${custom_message}")"
	printf "Assertion failed. ${message_to_use}\n"
	exit ${SBU_FAILURE_STATUS_CODE}
}

function assertion::_get_assertion_message_to_use() {
	local message=$1
	local custom_messsage=$2
	if [[ -n "${custom_messsage}" ]]; then
		printf "%s %s\n" "${message}" "${custom_messsage}"
	else
		printf "${message}\n"
	fi
}