function system::get_string_or_default_if_empty() {
	local string=$1; local default_string=$2
	local result=${string}
	if [[ -z "${string}" ]]; then
		result="${default_string}"
	fi
	printf "${result}"
}

function system::get_date_in_seconds() {
	date +%s
}

function system::print_with_color() {
	local text=$1; local color=$2; local default_color=$3
	printf "${color}${text}${default_color}\n"
}

function system::array_contains() {
	local value=${1}
	shift 1;
	local array=${@}
	local element; for element in ${array[@]}; do
		if [[ "${element}" == "${value}" ]]; then
			return ${SBU_SUCCESS_STATUS_CODE}
		fi
	done
	return ${SBU_FAILURE_STATUS_CODE}
}

function system::print_array() {
	local array=("${@}")
	local array_as_string=""
	local i; for (( i=0; i < ${#array[@]}; i++ )); do
		array_as_string+="${array[${i}]}, "
	done
	array_as_string=${array_as_string/%, /}
	printf "[%s]" "${array_as_string}"
}