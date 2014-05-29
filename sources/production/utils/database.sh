function database__initialise() {
  _database__create_token
  _database__ensure_directory_exists
}

function _database__create_token() {
  _SBU_DB_TOKEN="$(uuidgen)"
}

function database__destroy() {
  rm -rf "$(_database__get_dir)"
}

function database__put() {
  _database__ensure_directory_exists
  printf "%s" "$2" > "$(_database__get_dir)/$1"
}

function database__post() {
  _database__ensure_directory_exists
  printf "%s" "$2" >> "$(_database__get_dir)/$1"
}

function database__put_variable() {
  _database__ensure_directory_exists
  database__put "$1" "${!1}"
}

function database__get() {
  [[ -e "$(_database__get_dir)/$1" ]] && cat "$(_database__get_dir)/$1"
}

function _database__ensure_directory_exists() {
  mkdir -p "$(_database__get_dir)"
}

function _database__get_dir() {
  printf "${SBU_DB_DIR}/${_SBU_DB_TOKEN}"
}