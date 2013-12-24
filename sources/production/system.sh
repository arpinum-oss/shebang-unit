function system::get_string_or_default_if_empty() {
	local string=$1
	local default_string=$2
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
	printf "$2$1$3\n"
}

function system::array_contains() {
	local value=${1}
	local array=("${@:2}")
	local i; for (( i=0; i < ${#array[@]}; i++ )); do
		if [[ "${array[${i}]}" == "${value}" ]]; then
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

function system::string_contains() {
	[[ "$1" == *"$2"* ]]
}