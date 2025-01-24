#!/usr/bin/env bash

# Convention:
# Use echo to return
# Use printf to print log
# Wrap every variable in if statements with quotes, except for $? or something you sure that won't have white spaces
# In fact, just wrap every variables in if statements with quotes except for $?
# Wrap every variables that may contain white spaces or empty

SCRIPT_DIR=$(dirname $(realpath $BASH_SOURCE[0]))

trim_data() {
  local data=
  data="${1%%#*}"                         # Remove commented
  data="${data#"${data%%[![:space:]]*}"}" # Remove leading white spaces
  data="${data%"${data##*[![:space:]]}"}" # Remove trailing white spaces
  [[ -z "${data}" ]] && return 1
  echo "${data}"
}

expand_path() {
  local path="$1"
  [[ ${path} == "%SCRIPT_DIR%/"* ]] && path="${path//%SCRIPT_DIR%/${SCRIPT_DIR}}" # Replace %SCRIPT_DIR% with actual SCRIPT_DIR
  [[ ${path} == "%HOME%/"* ]] && path="${path//%HOME%/${HOME}}"                   # Replace %HOME% with actual HOME
  echo ${path}
}

make_symlink() {
  local source="$1"
  local destination="$2"

  if [[ ! -e "${source}" ]]; then
    echo "Invalid source."
    return 1
  fi

  if [[ -L "${destination}" ]] && [[ "$(realpath ${destination})" = "${source}" ]]; then
    echo "Already linked, skipping."
    return 0
  fi

  if [[ -e "${destination}" ]]; then
    echo "Destination existed."
    return 2
  fi

  output=$(ln -s ${source} ${destination} 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "${output}"
    return 3
  fi

  echo "Linked ${source} -> ${destination}"
}

make_copy() {
  local source="$1"
  local destination="$2"
  local source_type="$(stat --format='%F' ${source})"

  if [[ ! -e "${source}" ]]; then
    echo "Invalid source."
    return 1
  fi

  if [[ -e "${destination}" ]]; then
    local destination_type="$(stat --format='%F' ${destination})"

    if [[ "${source_type}" = 'regular file' ]] && [[ "${destination_type}" = 'regular file' ]]; then

      local hash_source="$(md5sum ${source} 2>/dev/null)"
      local hash_destination="$(md5sum ${destination} 2>/dev/null)"

      if [[ "${hash_source%% *}" = "${hash_destination%% *}" ]]; then
        echo "Same file, skipping."
        return 0
      fi

    fi

    echo "Destination existed."
    return 2
  fi

  local output=
  local status=0

  case "${source_type}" in
  'regular file')
    output=$(cp ${source} ${destination} 2>&1)
    status=$?
    ;;
  directory)
    output=$(cp -r ${source} ${destination} 2>&1)
    status=$?
    ;;
  *)
    echo "Unsupported type."
    return 5
    ;;
  esac

  if [[ "${status}" -ne 0 ]]; then
    echo "${output}"
    return 6
  fi

  echo "Copied ${source} -> ${destination}"
}

process_manifest() {
  IFS="|" read -r operation source destination <<<"$1"

  if [[ -z "${operation}" || -z "${source}" || -z "${destination}" ]]; then
    echo "Invalid manifest format."
    return 1
  fi

  source=$(expand_path ${source})
  destination=$(expand_path ${destination})

  local output=
  local status=0

  case $operation in
  symlink)
    output=$(make_symlink ${source} ${destination})
    status=$?
    ;;
  copy)
    output=$(make_copy ${source} ${destination})
    status=$?
    ;;
  extract) ;;
  *)
    echo "Unknown operation."
    return 2
    ;;
  esac

  echo "${output}"
  [[ "${status}" -ne 0 ]] && return 3 || return 0
}

load_manifest() {
  if [[ -z "$1" ]]; then
    echo "[ERROR] Missing manifest."
    return 1
  fi

  if [[ ! -f "$1" ]]; then
    echo "[ERROR] Manifest file not found."
    return 2
  fi

  local line_number=0

  while read -r line; do
    line_number=$((${line_number} + 1))

    line=$(trim_data "${line}")
    [[ $? -ne 0 ]] && continue

    output=$(process_manifest "${line}")

    if [[ $? -ne 0 ]]; then
      printf "[ERROR] Line ${line_number}: ${output}\n"
      return 1
    fi

    printf "[INFO]  Line ${line_number}: ${output}\n"
  done <"$1"

  printf "[OK]    Completed.\n"
}

# ------------------------- MAIN -------------------------

load_manifest "$1"
