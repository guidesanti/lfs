#!/bin/bash

source ./utils.sh
source ./common.sh

help () {
  printf "SYNOPSIS\n"
  printf "%5s%s\n" "" "prepare.sh [OPTIONS] <COMMAND> [PARAMETERS]"
  printf "\n\n"

  printf "DESCRIPTION\n"
  printf "%5s%s\n" "" "Executes the stage 0 which is comprised of the following steps:"
  printf "%5s%s\n" "" "Step 0: Prepare the sources folder"
  printf "%5s%s\n" "" "Step 1: Download all the packages"
  printf "%5s%s\n" "" "Step 2: Verify all the packages MD5 sum"
  printf "\n\n"

  printf "OPTIONS\n"
  printf "%5s%-20s %s\n" "" "--skip-download" "Skip downloading the packages"
  printf "%5s%-20s %s\n" "" "--skip-checksum" "Skip checking the packages MD5 sum"
  printf "\n\n"

  printf "COMMANDS\n"
  printf "%5s%-10s %s\n" "" "help" "Print this help"
  printf "%5s%-10s %s\n" "" "run" "Execute the stage"
  printf "\n"
}

# Prepare sources directory
prepare_sources_directory () {
  printf "%-100s" "Preparing sources directory '${LFS_SOURCES}'"
  if [[ ! -d "${LFS_SOURCES}" ]]; then
    sudo mkdir -v "${LFS_SOURCES}" &>> "${LOG_FILE}" || fail
  fi
  sudo chown -v "${LFS_USER}" "${LFS_SOURCES}" &>> "${LOG_FILE}" || fail
  sudo chmod -v a+wt "${LFS_SOURCES}" &>> "${LOG_FILE}" || fail
  ok
}

# Download packages and patches
download_packages_and_patches () {
  printf "%-100s" "Downloading all the required packages and patches into '${LFS_SOURCES}' ..."
  if [[ ${SKIP_DOWNLOAD} == "false" ]]; then
    printf "\n"
    INPUT=packages
    I=$((0))
    while IFS= read -r LINE
    do
      printf "%-100s" "${I}: Downloading '$LINE'"
      if wget "$LINE" --continue --directory-prefix="${LFS_SOURCES}" &>> "${LOG_FILE}"; then ok; else failed; fi
      ((I=I+1))
    done < "$INPUT"
  else
    skipped
    return
  fi
}

# Verify packages/patches MD5 sum
verify_packages_and_patches () {
  RESULT=0
  printf "%-100s" "Verifying packages MD5 sum"
  if [[ ${SKIP_CHECKSUM} == "false" ]]; then
    cp ./packages.md5 "${LFS_SOURCES}" &>> "${LOG_FILE}" || fail
    pushd "${LFS_SOURCES}" &>> "${LOG_FILE}" || fail
    md5sum --check --quiet packages.md5 &>> "${LOG_FILE}" || fail
    popd &>> "${LOG_FILE}" || return 1
  else
    skipped
  fi
  ok
}

# Create initial directory layout
create_lfs_directory_layout () {
  printf "%-100s" "Creating initial LFS directory layout"

  sudo mkdir -pv "${LFS}"/{etc,var} "${LFS}"/usr/{bin,lib,sbin} &>> "${LOG_FILE}" || fail
  for i in bin lib sbin; do
    if [[ -f "${LFS}/$i" || -d "${LFS}/$i" ]]; then
      log_warning "Skipping creating '${LFS}/$i', file already exist" &>> "${LOG_FILE}" || fail
    else
      sudo ln -sv usr/$i "${LFS}"/$i &>> "${LOG_FILE}" || fail
    fi
  done

  case $(uname -m) in
    x86_64)
      sudo mkdir -pv "${LFS}"/lib64 &>> "${LOG_FILE}" || fail
      ;;
  esac

  sudo mkdir -pv "${LFS}"/tools &>> "${LOG_FILE}" || fail
  ok
}

# Setup LFS user permissions on initial directory layout
setup_lfs_user_permissions () {
  printf "%-100s" "Setup LFS user permissions on initial directory layout"

  # Grant LFS user full access to all directories under $LFS
  sudo chown -v lfs "${LFS}"/{usr{,/*},lib,var,etc,bin,sbin,tools} &>> "${LOG_FILE}" || fail
  case $(uname -m) in
    x86_64)
      sudo chown -v lfs "${LFS}"/lib64 &>> "${LOG_FILE}" || fail
      ;;
  esac
  sudo chown -v lfs "${LFS_SOURCES}" &>> "${LOG_FILE}" || fail
  ok
}

run () {
  # Common steps
  sudo -v
  check_environment
  check_lfs_mount_point
  check_lfs_user
  prepare_log_file "prepare"
  # Custom steps
  prepare_sources_directory
  download_packages_and_patches
  verify_packages_and_patches
  create_lfs_directory_layout
  setup_lfs_user_permissions
}

SKIP_DOWNLOAD=false
SKIP_CHECKSUM=false

# Parse options
while [[ $# -gt 0 ]]; do
  KEY=$1
  case $KEY in
    --skip-download)
      SKIP_DOWNLOAD=true
      shift
      ;;

    --skip-checksum)
      SKIP_CHECKSUM=true
      shift
      ;;

    *)
      break
      ;;
  esac
done

# Read command
COMMAND=$1
shift

# Execute command
case ${COMMAND} in
  run)
    run
    ;;

  help|*)
    help
    ;;
esac

log_info "DONE"
printf "\n"
exit 0
