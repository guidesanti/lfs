#!/bin/bash

export BOLD=$'\e[1m'
export BLU=$'\e[1;34m'
export CYN=$'\e[1;36m'
export MAG=$'\e[1;35m'
export GRN=$'\e[1;32m'
export YEL=$'\e[1;33m'
export RED=$'\e[1;31m'
export END=$'\e[0m'

log_debug () {
  printf "${MAG}%-10s%s${END}\n" "[DEBUG] " "$1"
}

log_info () {
  printf "${GRN}%-10s%s${END}\n" "[INFO] " "$1"
}

log_warning () {
  printf "${YEL}%-10s%s${END}\n" "[WARNING] " "$1"
}

log_error () {
  printf "${RED}%-10s%s${END}\n" "[ERROR] " "$1"
}

log_warnings() {
  echo "$@"
  if [[ -n $1 ]]; then
    for i in "${@}"; do
      if [[ -z "${!i}" ]]; then
        log_warning "$i"
      fi
    done
  fi
}

log_errors() {
  echo "$@"
  if [[ -n $1 ]]; then
    for i in "${@}"; do
      if [[ -z "${!i}" ]]; then
        log_error "$i"
      fi
    done
  fi
}

fail () {
  failed
  if [[ -n $1 ]]; then
    log_error "$1"
    printf "\n"
  fi
  exit 1
}

ok () {
  printf "[ %s ]\n" "${GRN}OK${END}"
}

skipped () {
  printf "[ %s ]\n" "${YEL}SKIPPED${END}"
}

failed () {
  printf "[ %s ]\n" "${RED}FAILED${END}"
}
