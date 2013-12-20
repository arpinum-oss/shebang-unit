function fizzbuzz_enumerate() {
	local result=()
	local i; for i in {1..100}; do
		result+=($(_getValueForNumber "${i}"))
	done
	printf "%s " "${result[@]}"
}

function _getValueForNumber() {
	local number=${1}
	local result=$(_printValueIfNumberIsMultipleOfDivisor "Fizz" "${number}" 3)
	result+=$(_printValueIfNumberIsMultipleOfDivisor "Buzz" "${number}" 5)
	_printValueOfDefaultIfEmpty "${result}" "${number}"
}

function _printValueIfNumberIsMultipleOfDivisor() {
	local value=${1}; local number=${2}; local divisor=${3}
	if _numberIsMultipleOfTheOtherNumber "${number}" "${divisor}"; then
		printf "${value}"
	else
		printf ""
	fi
}

function _numberIsMultipleOfTheOtherNumber() {
	(( ${1}%${2} == 0 ))
}

function _printValueOfDefaultIfEmpty() {
	local value=${1}; local default=${2}
	if [[ "${value}" != "" ]]; then
		printf "${value}"
	else
		printf "${default}"
	fi
}
