function assertion::equal() {
	local expected=$1; local actual=$2
	if [[ "${expected}" != "${actual}" ]]; then
		_assertion_failed "Actual : <${actual}>, expected : <${expected}>."
	fi
}

function assertion::string_contains() {
	local container=$1; local contained=$2
	if ! _string_contains "${container}" "${contained}"; then
		_assertion_failed "String: <${container}> does not contain: <${contained}>."
	fi
}

function assertion::string_does_not_contain() {
	local container=$1; local contained=$2
	if _string_contains "${container}" "${contained}"; then
		_assertion_failed "String: <${container}> contains: <${contained}>."
	fi
}

function _string_contains() {
	local container=$1; local contained=$2
	[[ "${container}" == *"${contained}"* ]]
}

function assertion::status_code_is_success() {
	local status_code=$1; local custom_message=$2
	if (( ${status_code} != ${SUCCESS_STATUS_CODE} )); then
		_assertion_failed "Status code is failure instead of success." "${custom_message}"
	fi
}

function assertion::status_code_is_failure() {
	local status_code=$1; local custom_message=$2
	if (( ${status_code} == ${SUCCESS_STATUS_CODE} )); then
		_assertion_failed "Status code is success instead of failure." "${custom_message}"
	fi
}

function _assertion_failed() {
	local message=$1; local custom_message=$2
	local message_to_use="$(_get_assertion_message_to_use "${message}" "${custom_message}")"
	printf "Assertion failed. ${message_to_use}\n"
	exit ${FAILURE_STATUS_CODE}
}

function _get_assertion_message_to_use() {
	local message=$1; local custom_messsage=$2
	if [[ -n "${custom_messsage}" ]]; then
		printf "%s %s\n" "${message}" "${custom_messsage}"
	else
		printf "${message}\n"
	fi
}