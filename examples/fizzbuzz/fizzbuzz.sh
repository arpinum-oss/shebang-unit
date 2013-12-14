function fizzbuzz_enumerate() {
	local result=()
	local i; for i in {1..100}; do
		result+=($(_getValueForNumber ${i}))
	done
	printf "%s " "${result[@]}"
}

function _getValueForNumber() {
	local result=${1}
	if _numberIsMultipleOfTheOtherNumber ${result} 15; then
		printf "FizzBuzz"
	elif _numberIsMultipleOfTheOtherNumber ${result} 3; then
		printf "Fizz"
	elif _numberIsMultipleOfTheOtherNumber ${result} 5; then
		printf "Buzz"
	else
		printf ${result}
	fi
}

function _numberIsMultipleOfTheOtherNumber() {
	(( ${1}%${2} == 0 ))
}