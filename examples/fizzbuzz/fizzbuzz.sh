function fizzbuzz_enumerate() {
	local result=""
	local i; for i in {1..100}; do
		result="${result} ${i}"
	done
	printf "${result}"
}