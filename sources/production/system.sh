function system::get_string_or_default() {
	local result=$1
	[[ -z "$1" ]] && result="$2"
	printf "${result}"
}

function system::get_date_in_seconds() {
	date +%s
}

function system::print_with_color() {
	if [[ "${SBU_USE_COLORS}" == "${SBU_YES}" ]]; then
		printf "$2$1$3\n"
	else
		printf "$1\n"
	fi
}

function system::array_contains() {
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

function system::print_array() {
	local array_as_string=""
	local i
	for (( i=1; i <= $#; i++ )); do
		array_as_string+="${!i}, "
	done
	array_as_string=${array_as_string/%, /}
	printf "[%s]" "${array_as_string}"
}

function system::string_contains() {
	[[ "$1" == *"$2"* ]]
}