function system__get_string_or_default() {
	local result=$1
	[[ -z "$1" ]] && result="$2"
	printf "${result}"
}

function system__get_date_in_seconds() {
	date +%s
}

function system__print_with_color() {
	if [[ "${SBU_USE_COLORS}" == "${SBU_YES}" ]]; then
		printf "$2$1${SBU_DEFAULT_COLOR_CODE}"
	else
		printf "$1"
	fi
}

function system__array_contains() {
	local value=$1
	shift 1
	local i
	for (( i=1; i <= $#; i++ )); do
		if [[ "${!i}" == "${value}" ]]; then
			return ${SBU_SUCCESS_STATUS_CODE}
		fi
	done
	return ${SBU_FAILURE_STATUS_CODE}
}

function system__print_array() {
	local array_as_string=""
	local i
	for (( i=1; i <= $#; i++ )); do
		array_as_string+="${!i}, "
	done
	array_as_string=${array_as_string/%, /}
	printf "[%s]" "${array_as_string}"
}

function system__string_contains() {
	[[ "$1" == *"$2"* ]]
}