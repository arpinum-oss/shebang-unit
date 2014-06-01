function configuration_load() {
  # yes/no representation used with shebang_unit parameters to activate
  # stuff like colors
  SBU_YES="yes"
  SBU_NO="no"

  # Colors for outputs
  SBU_GREEN_COLOR_CODE="\\033[1;32m"
  SBU_RED_COLOR_CODE="\\033[1;31m"
  SBU_DEFAULT_COLOR_CODE="\\e[0m"

  # Functions coding coventions
  SBU_GLOBAL_SETUP_FUNCTION_NAME="global_setup"
  SBU_GLOBAL_TEARDOWN_FUNCTION_NAME="global_teardown"
  SBU_SETUP_FUNCTION_NAME="setup"
  SBU_TEARDOWN_FUNCTION_NAME="teardown"
  SBU_FUNCTION_DECLARATION_REGEX="^[ ]*function \(.*\)()"
  SBU_PRIVATE_FUNCTION_NAME_REGEX="^_.*"

  # Default configuration that can be modified with shebang_unit parameters
  # For more information see shebang_unit usages
  SBU_TEST_FILE_PATTERN="*_test.sh"
  SBU_USE_COLORS="${SBU_YES}"
  SBU_REPORTERS="simple"

  # Internal constants
  SBU_SUCCESS_STATUS_CODE=0
  SBU_FAILURE_STATUS_CODE=1
  SBU_VALUE_SEPARATOR=","
  SBU_TEMP_DIR="/tmp/.shebang_unit"
  SBU_LAST_ASSERTION_MSG_KEY="last_assertion_message"
  SBU_REPORTERS_FD=3
}

configuration_load