function fizzbuzz::enumerate() {
	local i
	for i in {1..100}; do
		printf "%s " "$(fizzbuzz::_get_value_for_number ${i})"
	done
}

function fizzbuzz::_get_value_for_number() {
	local number=$1
	local result="$(fizzbuzz::_print_value_if_multiple "Fizz" ${number} 3)"
	result+="$(fizzbuzz::_print_value_if_multiple "Buzz" ${number} 5)"
	fizzbuzz::_print_value_of_default_if_empty "${result}" ${number}
}

function fizzbuzz::_print_value_if_multiple() {
	local value=$1; local number=$2; local divisor=$3
	if fizzbuzz::_number_is_multiple ${number} ${divisor}; then
		printf "${value}"
	else
		printf ""
	fi
}

function fizzbuzz::_number_is_multiple() {
	(( $1 % $2 == 0 ))
}

function fizzbuzz::_print_value_of_default_if_empty() {
	local value=$1; local default=$2
	if [[ -n "${value}" ]]; then
		printf "${value}"
	else
		printf "${default}"
	fi
}
