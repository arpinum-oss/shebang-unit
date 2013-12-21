SUCCESS_STATUS_CODE=0
FAILURE_STATUS_CODE=1

function system::getStringOfDefaultIfEmpty() {
	local string=$1; local defaultString=$2
	local result=${string}
	if [[ -z "${string}" ]]; then
		result="${defaultString}"
	fi
	printf "${result}"
}

function system::getDateInSeconds() {
	date +%s
}

function system::printWithColor() {
	local text=$1; local color=$2; local defaultColor=$3
	printf "${color}${text}${defaultColor}\n"
}