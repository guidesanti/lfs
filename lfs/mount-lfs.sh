#!/bin/bash

if [[ "${LFS_DEBUG}" == "true" ]]; then
  set -x
fi

source ./utils.sh

sudo -v || fail

check_environment

# Prepare log directory and log file
if [[ ! -d ${LFS_LOG_DIR} ]]; then
  sudo mkdir -pv "${LFS_LOG_DIR}" || log_error "Failed to create LFS log directory '${LFS_LOG_DIR}'"
  sudo chmod a+wr "${LFS_LOG_DIR}" || log_error "Failed to set permissions on  LFS log directory '${LFS_LOG_DIR}'"
fi
LOG_FILE="${LFS_LOG_DIR}/mount-$(date --utc +%s).log"
touch "${LOG_FILE}"
chmod a+r "${LOG_FILE}" || log_error "Failed to set permissions on log file '${LOG_FILE}'"

# Check/create LFS mount point
printf "%-50s" "Checking/creating mount point '${LFS}'"
if [[ ! -d ${LFS} ]]; then
  sudo mkdir -pv "${LFS}" &>> "${LOG_FILE}" || failed
fi
ok

# Mount LFS partition
printf "%-50s" "Mounting LFS partition '${LFS_PARTITION}' on '${LFS}'"
MOUNT=$(cat < /proc/mounts | grep "${LFS_PARTITION}")
if [[ -z ${MOUNT} ]]; then
  sudo mount -v -t ext4 "${LFS_PARTITION}" "${LFS}" &>> "${LOG_FILE}" || failed
fi
ok

log_info "Log file: ${LOG_FILE}"
printf "\n"
