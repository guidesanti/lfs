source ./utils.sh

LFS_ENV=('LFS_GROUP' 'LFS_USER' 'LFS_PARTITION' 'LFS' 'LFS_SOURCES' 'LFS_TOOLS' 'LFS_CONFIG_SITE' 'LFS_DEBUG' 'LFS_LOG_DIR' 'LFS_TARGET')

# Check LFS environment
check_environment () {
  ERRORS=()
  printf "%-100s" "Checking LFS environment ..."
  for i in "${LFS_ENV[@]}"; do
    if [[ -z "${!i}" ]]; then
      ERRORS+=("$i")
    fi
  done

  if [[ ${#ERRORS[@]} -eq 0 ]]; then
    ok
#    log_info "LFS environment looks good!"
  else
    failed
    for i in "${ERRORS[@]}"; do
      log_error "Variable $i is not set"
    done
    log_error "Looks like the LFS environment was not set, make sure to execute 'source ./env.sh set' before using this tool."
    printf "\n"
    exit 1
  fi
}

# Check LFS mount point
check_lfs_mount_point () {
  printf "%-100s" "Checking LFS mount point ..."
  MOUNT=$(cat < /proc/mounts | grep "${LFS_PARTITION}")
  if [[ -n ${MOUNT} ]]; then
    ok
#    log_info "LFS mount point looks good!"
  else
    fail "Looks like LFS partition is not mounted!"
  fi
}

# Check LFS user
check_lfs_user () {
  printf "%-100s" "Checking LFS user ..."
  I=$(whoami)
  if [[ ${I} == "${LFS_USER}" ]]; then
    ok
#    log_info "LFS user looks good!"
  else
    failed
    log_error "Looks like you are not executing this as LFS user!"
    log_error "LFS_USER is '${LFS_USER}', you are '${I}'"
    log_info "Make sure to execute 'su - \$LFS_USER' before using this tool."
    printf "\n"
    exit 1
  fi
}

# Prepare log directory and log file
prepare_log_file() {
  ERRORS=()
  printf "%-100s" "Preparing LFS logs ..."

  # Create log directory if not exist
  if [[ ! -d ${LFS_LOG_DIR} ]]; then
    sudo mkdir -pv "${LFS_LOG_DIR}" || ERRORS+=("Failed to create LFS log directory '${LFS_LOG_DIR}'")
    sudo chmod a+wr "${LFS_LOG_DIR}" || ERRORS+=("Failed to set permissions on LFS log directory '${LFS_LOG_DIR}'")
  fi

  # Set log file path and name
  PREFIX=$1
  if [[ -z ${PREFIX} ]];then
    LOG_FILE="${LFS_LOG_DIR}/$(date --utc +%s).log"
  else
    LOG_FILE="${LFS_LOG_DIR}/${PREFIX}-$(date --utc +%s).log"
  fi

  touch "${LOG_FILE}"
  chmod a+r "${LOG_FILE}" || ERRORS+=("Failed to set permissions on log file '${LOG_FILE}'")

  if [[ ${#ERRORS[@]} -eq 0 ]]; then
    ok
    log_info "Log file: ${LOG_FILE} (run 'tail -f ${LOG_FILE}' on another terminal to follow the detailed logs)"
  else
    failed
    log_errors "${ERRORS[@]}"
  fi
}
