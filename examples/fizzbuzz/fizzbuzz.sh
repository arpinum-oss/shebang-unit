function fizzbuzz_enumerate() {
	local result=()
	local i; for i in {1..100}; do
		result[${i}]=$(_getValueForNumber ${i})
	done
	printf "%s " "${result[@]}"
}

function _getValueForNumber() {
	local number=${1}
	if _numberIsMultipleOfTheOtherNumber ${number} 3; then
		printf "Fizz"
	else
		printf ${number}
	fi
}

function _numberIsMultipleOfTheOtherNumber() {
	(( ${1}%${2} == 0 ))
}