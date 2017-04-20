mock__make_function_do_nothing() {
  mock__make_function_call "$1" ":"
}

mock__make_function_prints() {
  local function="$1"
  local text="$2"
  eval "${function}() { printf \"${text}\"; }"
}

mock__make_function_call() {
  local function_to_mock="$1"
  local function_to_call="$2"
  shift 2
  eval "${function_to_mock}() { ${function_to_call} \"\$@\"; }"
}
