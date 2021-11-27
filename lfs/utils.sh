#!/bin/bash

export RED=$'\e[1;31m'
export GRN=$'\e[1;32m'
export YEL=$'\e[1;33m'
export BLU=$'\e[1;34m'
export MAG=$'\e[1;35m'
export CYN=$'\e[1;36m'
export END=$'\e[0m'

log_info () {
  printf "${GRN}%-10s%s${END}\n" "[INFO] " "$1"
}

log_warning () {
  printf "${YEL}%-10s%s${END}\n" "[WARNING] " "$1"
}

log_error () {
  printf "${RED}%-10s%s${END}\n" "[ERROR] " "$1"
}

# Check if the LFS environment is ok
# Parameter 1: Exit on error
#   'true' to exit if error
#   'false' otherwise, in this case the function will return a value of 1 if error
check_environment () {
  RESULT=0
  if [[ -z "${LFS_PARTITION}" ]]; then
    printf "ERROR: Variable LFS_PARTITION is not set\n"
    RESULT=1
  fi
  if [[ -z "${LFS}" ]]; then
    echo "ERROR: Variable LFS is not set"
    RESULT=1
  fi
  if [[ -z "${LFS_SOURCES}" ]]; then
      echo "ERROR: Variable LFS_SOURCES is not set"
      RESULT=1
    fi
  if [[ ${RESULT} -eq 0 ]]; then
    printf "LFS environment looks good!\n"
  else
    printf "Looks like the LFS environment was not set!\n"
    printf "Make sure to execute 'source ./set-env.sh' before using this tool.\n"
    printf "\n"
    if [[ "$1" == "true" ]]; then
      exit 1
    fi
  fi
  printf "\n"
  return ${RESULT}
}
