#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $BASH_SOURCE[0]))
SKIP_ERROR=false
MANIFEST_FILE=""

print_help() {
  echo "Unimplemented."
}

trim_data() {
  local data=

  data="${1%%#*}"                         # Remove commented
  data="${data#"${data%%[![:space:]]*}"}" # Remove leading white spaces
  data="${data%"${data##*[![:space:]]}"}" # Remove trailing white spaces

  [[ -z "${data}" ]] && return 1 || echo "${data}"
}

expand_path() {
  local path="$1"

  [[ ${path} = "{SCRIPT_DIR}/"* ]] && path="${path//\{SCRIPT_DIR\}/${SCRIPT_DIR}}" # Replace {SCRIPT_DIR} with actual SCRIPT_DIR
  [[ ${path} = "{HOME}/"* ]] && path="${path//\{HOME\}/${HOME}}"                   # Replace {HOME} with actual HOME
  [[ ${path:0:1} = "~" ]] && path="${path//\~/${HOME}}"                            # Replace ~ with actual HOME

  echo ${path}
}

make_symlink() {
  local source="$1"
  local destination="$2"
  local destination_dir=$(dirname ${destination})

  if [[ ! -e ${source} ]]; then
    echo "Invalid source."
    return 1
  fi

  if [[ ! -d ${destination_dir} ]]; then
    mkdir -p ${destination_dir} || {
      echo "Cannot create dir: ${destination_dir}"
      return 1
    }
  fi

  [[ "$(realpath ${destination} 2>/dev/null)" = ${source} ]] && {
    echo "Already linked, skipping."
    return 0
  }

  if [[ -e ${destination} ]]; then
    echo "Destination existed."
    return 1
  fi

  output=$(ln -s ${source} ${destination} 2>&1)

  if [[ $? -ne 0 ]]; then
    echo "${output}"
    return 1
  fi

  echo "Linked ${source} -> ${destination}"
}

make_copy() {
  local source="$1"
  local destination="$2"
  local destination_dir=$(dirname ${destination})
  local source_type="$(stat --format="%F" ${source} 2>/dev/null)"

  if [[ ! -e ${source} ]]; then
    echo "Invalid source."
    return 1
  fi

  if [[ ! -d ${destination_dir} ]]; then
    mkdir -p ${destination_dir} || {
      echo "Cannot create dir: ${destination_dir}"
      return 1
    }
  fi

  if [[ -e ${destination} ]]; then
    local destination_type="$(stat --format='%F' ${destination})"

    if [[ "${source_type}" = "regular file" && "${destination_type}" = "regular file" ]]; then

      local hash_source="$(md5sum ${source} 2>/dev/null)"
      local hash_destination="$(md5sum ${destination} 2>/dev/null)"

      if [[ "${hash_source%% *}" = "${hash_destination%% *}" ]]; then
        echo "Same file, skipping."
        return 0
      fi

    fi

    echo "Destination existed."
    return 1
  fi

  local output=
  local status=0

  case "${source_type}" in
  "regular file")
    output=$(cp ${source} ${destination} 2>&1)
    status=$?
    ;;
  directory)
    output=$(cp -r ${source} ${destination} 2>&1)
    status=$?
    ;;
  *)
    echo "Unsupported type."
    return 1
    ;;
  esac

  if [[ "${status}" -ne 0 ]]; then
    echo "${output}"
    return 1
  fi

  echo "Copied ${source} -> ${destination}"
}

extract_archive() {
  local archive_path=$1
  local extract_location=$2

  if [[ ! -f ${archive_path} ]]; then
    echo "Archive not existed."
    return 1
  fi

  if [[ ! -d ${extract_location} ]]; then
    mkdir -p ${extract_location} || {
      echo "Cannot create dir: ${extract_location}"
      return 1
    }
  fi

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

  if [[ "${status}" -ne 0 ]]; then
    echo "${output}"
    return 3
  fi

  echo "Extracted ${archive_path} -> ${extract_location}"
}

process_manifest() {
  if [[ "$1" == *" "* ]]; then
    echo "Manifest contain white spaces."
    return 1
  fi

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
  extract)
    output=$(extract_archive ${source} ${destination})
    status=$?
    ;;
  *)
    echo "Unknown operation."
    return 1
    ;;
  esac

  echo "${output}"
  [[ "${status}" -ne 0 ]] && return 1 || return 0
}

load_manifest() {
  if [[ -z "$1" ]]; then
    printf "[ERROR] Missing manifest file.\n"
    return 1
  fi

  if [[ ! -f "$1" ]]; then
    printf "[ERROR] Manifest file not found.\n"
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
      ${SKIP_ERROR} && continue || return 1
    fi

    printf "[INFO]  Line ${line_number}: ${output}\n"
  done <"$1"
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --skip-error)
      SKIP_ERROR=true
      shift
      ;;
    -*)
      printf "[ERROR] Unknown options: $1\n"
      return 1
      ;;
    *)
      if [[ -n "$MANIFEST_FILE" ]]; then
        printf "[ERROR] Unexpected argument: $1\n"
        return 1
      fi
      MANIFEST_FILE="$1"
      shift
      ;;
    esac
  done
}

# ------------------------- MAIN -------------------------

parse_arguments "$@" && load_manifest "${MANIFEST_FILE}"
RESULT=$?

printf "%s\n" "-----------------------------"
if [[ "${RESULT}" -eq 0 ]]; then
  printf ">>> Completed.\n"
else
  printf ">>> Failed to setup dotfiles.\n"
fi
