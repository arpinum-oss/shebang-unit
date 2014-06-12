function mock__make_function_prints() {
  local function=$1
  local text=$2
  eval "function ${function}() { printf "${text}"; }"
}