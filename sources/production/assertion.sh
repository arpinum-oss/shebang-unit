function assertEqual() {
	local expected=$1; local actual=$2
	if [[ "${expected}" != "${actual}" ]]; then
		_assertionFailed "Actual : <${actual}>, expected : <${expected}>."
	fi
}

function assertStringContains() {
	local container=$1; local contained=$2
	if ! _stringContains "${container}" "${contained}"; then
		_assertionFailed "String: <${container}> does not contain: <${contained}>."
	fi
}

function assertStringDoesNotContain() {
	local container=$1; local contained=$2
	if _stringContains "${container}" "${contained}"; then
		_assertionFailed "String: <${container}> contains: <${contained}>."
	fi
}

function _stringContains() {
	local container=$1; local contained=$2
	[[ "${container}" == *"${contained}"* ]]
}

function assertStatusCodeIsSuccess() {
	local statusCode=$1; local customMessage=$2
	if (( ${statusCode} != ${SUCCESS_STATUS_CODE} )); then
		_assertionFailed "Status code is failure instead of success." "${customMessage}"
	fi
}

function assertStatusCodeIsFailure() {
	local statusCode=$1; local customMessage=$2
	if (( ${statusCode} == ${SUCCESS_STATUS_CODE} )); then
		_assertionFailed "Status code is success instead of failure." "${customMessage}"
	fi
}

function _assertionFailed() {
	local message=$1; local customMessage=$2
	local messageToUse="$(_getAssertionMessageToUse "${message}" "${customMessage}")"
	printf "Assertion failed. ${messageToUse}\n"
	exit ${FAILURE_STATUS_CODE}
}

function _getAssertionMessageToUse() {
	local message=$1; local customMesssage=$2
	if [[ -n "${customMesssage}" ]]; then
		printf "%s %s\n" "${message}" "${customMesssage}"
	else
		printf "${message}\n"
	fi
}