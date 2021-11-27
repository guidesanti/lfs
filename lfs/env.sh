#!/bin/bash

DEFAULT_LFS_PARTITION=/dev/sda4
DEFAULT_LFS=/mnt/lfs

help () {
  printf "SYNOPSIS\n"
  printf "%5s%s" "" "env.sh [OPTIONS] <COMMAND> [PARAMETERS]\n"
  printf "\n\n"

  printf "OPTIONS\n"
  printf "%5s%-30s %s\n" "" "No options available yet" ""
  printf "\n\n"

  printf "COMMANDS\n"
  printf "%5s%-30s %s\n" "" "help" "Print this help"
  printf "%5s%-30s %s\n" "" "show" "Show the current LFS environment"
  printf "%5s%-30s %s\n" "" "set" "Set LFS environment"
  printf "%10s%-30s %s\n" "" "--lfs-partition <PARTITION>" "Set the path for the LFS partition, defaults to $DEFAULT_LFS_PARTITION"
  printf "%10s%-30s %s\n" "" "--lfs-root <ROOT_PATH>" "Set the LFS root path, defaults to $DEFAULT_LFS"
  printf "%5s%-30s %s\n" "" "unset" "Unset LFS environment"
  printf "\n\n"
  printf "NOTE:\n"
  printf "%5s%s\n" "" "For the commands set and unset to take effect you should run this script with"
  printf "%5s%s\n" "" "'source ./env.sh' instead of './env.sh'"
  printf "\n"
}

show_env () {
  printf "%-30s %s\n" "LFS_PARTITION:" "${LFS_PARTITION}"
  printf "%-30s %s\n" "LFS:" "${LFS}"
  printf "%-30s %s\n" "LFS_SOURCES:" "${LFS_SOURCES}"
  printf "\n"
}

set_env () {
  export LFS_PARTITION=${LFS_PARTITION:-${DEFAULT_LFS_PARTITION}}
  export LFS=${LFS:-${DEFAULT_LFS}}
  export LFS_SOURCES=${LFS}/sources

  printf "LFS environment successfully set\n"
  printf "=========================================\n"
  show_env
}

read_set_env_params () {
  while [[ $# -gt 0 ]]; do
    KEY=$1
    case $KEY in
      --lfs-partition)
        LFS_PARTITION=$2
        shift
        shift
        ;;

      --lfs-root)
        LFS=$2
        shift
        shift
        ;;

      *)
        help
        exit 0
        ;;
    esac
  done
}

unset_env () {
  unset LFS_PARTITION
  unset LFS
  unset LFS_SOURCES

  printf "LFS environment successfully cleared\n"
  printf "=========================================\n"
  show_env
}

# Read command
COMMAND=$1
shift

# Execute command
case ${COMMAND} in
  show)
    show_env
    ;;

  set)
    read_set_env_params "$@"
    set_env
    ;;

  unset)
    unset_env
    ;;

  help|*)
    help
    ;;
esac
