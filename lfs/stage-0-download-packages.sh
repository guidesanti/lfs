#!/bin/bash

source ./utils.sh

LOG_FILE=stage-0.log

failed () {
  printf "FAILED\n"
}

help () {
  printf "SYNOPSIS\n"
  printf "%5s%s\n" "" "stage-0-download-packages.sh [OPTIONS] <COMMAND> [PARAMETERS]"
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

step0 () {
  RESULT=0
  log_info "Step 0: Preparing sources folder ${LFS_SOURCES}' ..."
  if [[ ! -d "${LFS_SOURCES}" ]]; then
    sudo mkdir -v "${LFS_SOURCES}" || RESULT=1
    sudo chmod -v a+wt "${LFS_SOURCES}" || RESULT=1
  fi
  if [[ ${RESULT} -eq 0 ]]; then
    log_info "Step 0: Preparing sources folder ${LFS_SOURCES}' [SUCCESS]"
  else
    log_error "Step 0: Preparing sources folder ${LFS_SOURCES}' [FAILED]"
  fi
  return $RESULT
}

step1 () {
  RESULT=0
  log_info "Step 1: Downloading all the required packages and patches into '${LFS_SOURCES}' ..."
  if [[ ${SKIP_DOWNLOAD} == "false" ]]; then
    INPUT=packages
    while IFS= read -r LINE
    do
      log_info "Downloading package/patch '$LINE' ..."
      wget $LINE --directory-prefix="${LFS_SOURCES}"
      if [[ $? -eq 0 ]]; then
        log_info "Downloading package/patch '$LINE' [SUCCESS]"
      else
        log_error "Downloading package/patch '$LINE' [FAILED]"
        RESULT=1
      fi
    done < "$INPUT"
#    wget --input-file=packages --continue --directory-prefix="${LFS_SOURCES}" &>> ${LOG_FILE} || ( failed && return 1 )
  else
    log_warning "Step 1: Downloading all the required packages and patches into '${LFS_SOURCES}' [SKIPPED]"
  fi
  if [[ ${RESULT} -eq 0 ]]; then
      log_info "Step 0: Preparing sources folder ${LFS_SOURCES}' [SUCCESS]"
    else
      log_error "Step 0: Preparing sources folder ${LFS_SOURCES}' [FAILED]"
    fi
    return $RESULT
}

step2 () {
  printf "Step 2: Verifying packages MD5 sum ... "
  if [[ ${SKIP_CHECKSUM} == "false" ]]; then
    cp ./packages.md5 "${LFS_SOURCES}"
    pushd "${LFS_SOURCES}" &>> ${LOG_FILE} || ( failed && return 1 )
    md5sum -c packages.md5
    echo "-----> " $?
    popd &>> ${LOG_FILE} || ( failed && return 1 )
    printf "DONE\n"
  else
    printf "SKIPPED\n"
  fi
  return 0
}

run () {
  check_environment true
  sudo -v
  step0 || return 1
  step1 || return 1
#  step2 || return 1
  return 0
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

if [[ $? -eq 0 ]]; then
  printf "Stage 0: DONE\n"
else
  printf "Stage 0: FAILED\n"
fi
printf "For details check the log file '%s'\n" "${LOG_FILE}"
printf "\n"
exit 0
