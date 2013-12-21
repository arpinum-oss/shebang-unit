function fizzbuzz_enumerate() {
	local enumeration=()
	local i; for i in {1..100}; do
		enumeration+=("$(_get_value_for_number ${i})")
	done
	printf "%s " ${enumeration[@]}
}

function _get_value_for_number() {
	local number=$1
	local result="$(_print_value_if_number_is_multiple_of_divisor "Fizz" ${number} 3)"
	result+="$(_print_value_if_number_is_multiple_of_divisor "Buzz" ${number} 5)"
	_print_value_of_default_if_empty "${result}" ${number}
}

function _print_value_if_number_is_multiple_of_divisor() {
	local value=$1; local number=$2; local divisor=$3
	if _number_is_multiple_of_the_other_number ${number} ${divisor}; then
		printf "${value}"
	else
		printf ""
	fi
}

function _number_is_multiple_of_the_other_number() {
	(( $1 % $2 == 0 ))
}

function _print_value_of_default_if_empty() {
	local value=$1; local default=$2
	if [[ -n "${value}" ]]; then
		printf "${value}"
	else
		printf "${default}"
	fi
}
