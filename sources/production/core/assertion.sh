function assertion__equal() {
	if [[ "$1" != "$2" ]]; then
		_assertion__failed "Actual: <$2>, expected: <$1>."
	fi
}

function assertion__different() {
	if [[ "$1" == "$2" ]]; then
		_assertion__failed "Both values are: <$1>."
	fi
}

function assertion__string_contains() {
	if ! system__string_contains "$1" "$2"; then
		_assertion__failed "String: <$1> does not contain: <$2>."
	fi
}

function assertion__string_does_not_contain() {
	if system__string_contains "$1" "$2"; then
		_assertion__failed "String: <$1> contains: <$2>."
	fi
}

function assertion__string_empty() {
	if [[ -n "$1" ]]; then
		_assertion__failed "String: <$1> is not empty."
	fi
}

function assertion__string_not_empty() {
	if [[ -z "$1" ]]; then
		_assertion__failed "The string is empty."
	fi
}

function assertion__array_contains() {
	local element=$1
	shift 1
	if ! system__array_contains "${element}" "$@"; then
		local array_as_string="$(system__print_array "$@")"
		_assertion__failed \
			"Array: <${array_as_string}> does not contain: <${element}>."
	fi
}

function assertion__array_does_not_contain() {
	local element=$1
	shift 1
	if system__array_contains "${element}" "$@"; then
		local array_as_string="$(system__print_array "$@")"
		_assertion__failed \
			"Array: <${array_as_string}> contains: <${element}>."
	fi
}

function assertion__status_code_is_success() {
	if (( $1 != ${SBU_SUCCESS_STATUS_CODE} )); then
		_assertion__failed \
			"Status code is failure instead of success." "$2"
	fi
}

function assertion__status_code_is_failure() {
	if (( $1 == ${SBU_SUCCESS_STATUS_CODE} )); then
		_assertion__failed \
			"Status code is success instead of failure." "$2"
	fi
}

function assertion__successful() {
	"$@"
	if (( $? != ${SBU_SUCCESS_STATUS_CODE} )); then
		_assertion__failed "Command is failing instead of successful."
	fi
}

function assertion__failing() {
	"$@"
	if (( $? == ${SBU_SUCCESS_STATUS_CODE} )); then
		_assertion__failed "Command is successful instead of failing."
	fi
}

function _assertion__failed() {
	local message_to_use="$(_assertion__get_assertion_message_to_use "$1" "$2")"
	printf "Assertion failed. ${message_to_use}\n"
	exit ${SBU_FAILURE_STATUS_CODE}
}

function _assertion__get_assertion_message_to_use() {
	local message=$1
	local custom_messsage=$2
	if [[ -n "${custom_messsage}" ]]; then
		printf "%s %s\n" "${message}" "${custom_messsage}"
	else
		printf "${message}\n"
	fi
}