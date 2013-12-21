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