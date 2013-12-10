function fizzbuzzShouldReturn1For1() {
	local result=$(fizzbuzz 1)

	assertEqual 1 ${result}
}