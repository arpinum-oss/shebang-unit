_DATA_BASE_DIR="/tmp/.sbu/database"

function database_initialise() {
  database_destroy
  mkdir -p "${_DATA_BASE_DIR}"
}

function database_destroy() {
  rm -rf "${_DATA_BASE_DIR}"
}

function database_put() {
  printf "%s" "$2" > "${_DATA_BASE_DIR}/$1"
}

function database_post() {
  printf "%s" "$2" >> "${_DATA_BASE_DIR}/$1"
}

function database_put_variable() {
  database_put "$1" "${!1}"
}

function database_get() {
  [[ -e "${_DATA_BASE_DIR}/$1" ]] && cat "${_DATA_BASE_DIR}/$1"
}