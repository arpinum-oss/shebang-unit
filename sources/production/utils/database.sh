function database__initialise() {
  database__destroy
  _database__ensure_directory_exists
}

function database__destroy() {
  rm -rf "${SBU_DB_DIR}"
}

function database__put() {
  _database__ensure_directory_exists
  printf "%s" "$2" > "${SBU_DB_DIR}/$1"
}

function database__post() {
  _database__ensure_directory_exists
  printf "%s" "$2" >> "${SBU_DB_DIR}/$1"
}

function database__put_variable() {
  _database__ensure_directory_exists
  database__put "$1" "${!1}"
}

function database__get() {
  [[ -e "${SBU_DB_DIR}/$1" ]] && cat "${SBU_DB_DIR}/$1"
}

function _database__ensure_directory_exists() {
  mkdir -p "${SBU_DB_DIR}"
}