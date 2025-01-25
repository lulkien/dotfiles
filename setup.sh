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

  [[ -z "${data}" ]] && return 1 || echo "${data}"
}

expand_path() {
  local path="$1"
  [[ ${path} == "{SCRIPT_DIR}/"* ]] && path="${path//\{SCRIPT_DIR\}/${SCRIPT_DIR}}" # Replace {SCRIPT_DIR} with actual SCRIPT_DIR
  [[ ${path} == "{HOME}/"* ]] && path="${path//\{HOME\}/${HOME}}"                   # Replace {HOME} with actual HOME
  [[ ${path:0:1} == "~" ]] && path="${path//\~/${HOME}}"                            # Replace ~ with actual HOME
  echo ${path}
}

make_symlink() {
  local source="$1"
  local destination="$2"

  [[ ! -e ${source} ]] && {
    echo "Invalid source."
    return 1
  }

  [[ "$(realpath ${destination})" = "${source}" ]] && {
    echo "Already linked, skipping."
    return 0
  }

  [[ -e ${destination} ]] && {
    echo "Destination existed."
    return 2
  }

  output=$(ln -s ${source} ${destination} 2>&1)
  [[ $? -ne 0 ]] && {
    echo "${output}"
    return 3
  }

  echo "Linked ${source} -> ${destination}"
}

make_copy() {
  local source="$1"
  local destination="$2"
  local source_type="$(stat --format='%F' ${source})"

  [[ ! -e ${source} ]] && {
    echo "Invalid source."
    return 1
  }

  if [[ -e ${destination} ]]; then

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
    return 3
    ;;

  esac

  if [[ "${status}" -ne 0 ]]; then
    echo "${output}"
    return 4
  fi

  echo "Copied ${source} -> ${destination}"
}

extract_archive() {
  local archive_path=$1
  local extract_location=$2

  [[ -f ${archive_path} ]] || {
    echo "Archive not existed."
    return 1
  }

  [[ -d ${extract_location} ]] || {
    echo "Extract location is not directory or not existed."
    return 2
  }

  local output=
  local status=0

  case "${archive_path}" in
  *.zip)
    output=$(unzip -qfo ${archive_path} -d ${extract_location} 2>&1)
    status=$?
    ;;

  *.tar.gz | *.tgz)
    output=$(tar -xzf ${archive_path} -C ${extract_location} 2>&1)
    status=$?
    ;;

  *.tar)
    output=$(tar -xf ${archive_path} -C ${extract_location} 2>&1)
    status=$?
    ;;

  *)
    echo "Unsupported archive type."
    return 2
    ;;

  esac

  [[ "${status}" -eq 0 ]] || {
    echo "${output}"
    return 3
  }

  echo "Extracted ${archive_path} -> ${extract_location}"
}

process_manifest() {
  [[ "$1" == *" "* ]] && {
    echo "Manifest contain white spaces."
    return 1
  }

  IFS="|" read -r operation source destination <<<"$1"

  [[ -z "${operation}" || -z "${source}" || -z "${destination}" ]] && {
    echo "Invalid manifest format."
    return 1
  }

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
  extract)
    output=$(extract_archive ${source} ${destination})
    status=$?
    ;;
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
