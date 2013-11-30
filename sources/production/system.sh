[[ "${SOURCE_SYSTEM}" != "" ]] && return || readonly SOURCE_SYSTEM=1

SUCCESS_STATUS_CODE=0
FAILURE_STATUS_CODE=1

function system_getStringOfDefaultIfEmpty() {
	local string=${1}; local defaultString=${2}
	local result=${string}
	if [[ "${string}" = "" ]]; then
		result="${defaultString}"
	fi
	printf "${result}"
}

function system_getDateInSeconds() {
	date +%s
}

function system_printWithColor() {
	local text=${1}; local color=${2}; local defaultColor=${3}
	printf "${color}${text}${defaultColor}\n"
}