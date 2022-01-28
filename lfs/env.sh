#!/bin/bash

DEFAULT_LFS_GROUP=lfs
DEFAULT_LFS_USER=lfs
DEFAULT_LFS_PARTITION=/dev/sda4
DEFAULT_LFS=/mnt/lfs
DEFAULT_LFS_LOG_DIR=/tmp/lfs
DEFAULT_LFS_DEBUG=false
LFS_ENV=('LFS_GROUP' 'LFS_USER' 'LFS_PARTITION' 'LFS' 'LFS_SOURCES' 'LFS_TOOLS' 'LFS_CONFIG_SITE' 'LFS_DEBUG' 'LFS_LOG_DIR' 'LFS_TARGET')

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
  printf "%10s%-30s %s\n" "" "--lfs-user <USER>" "Set the LFS user, defaults to $DEFAULT_LFS_USER"
  printf "%10s%-30s %s\n" "" "--lfs-partition <PARTITION>" "Set the path for the LFS partition, defaults to $DEFAULT_LFS_PARTITION"
  printf "%10s%-30s %s\n" "" "--lfs-root <ROOT_PATH>" "Set the LFS root path, defaults to $DEFAULT_LFS"
  printf "%10s%-30s %s\n" "" "--lfs-log-dir <DIR>" "Set the LFS logs directory, defaults to $DEFAULT_LFS_LOG_DIR"
  printf "%10s%-30s %s\n" "" "--debug" "Set the LFS debug to true, defaults to $DEFAULT_LFS_DEBUG"
  printf "%5s%-30s %s\n" "" "unset" "Unset LFS environment"
  printf "\n\n"
  printf "NOTE:\n"
  printf "%5s%s\n" "" "For the commands set and unset to take effect you should run this script with"
  printf "%5s%s\n" "" "'source ./env.sh' instead of './env.sh'"
  printf "\n"
}

show_env () {
  printf "=========================================\n"
  printf "LFS environment:\n"
  printf "=========================================\n"
  for i in "${LFS_ENV[@]}"; do
    printf "%-30s %s\n" "${i}:" "${!i}"
  done
  printf "\n"
}

set_env () {
  export LFS_GROUP=${LFS_GROUP:-${DEFAULT_LFS_GROUP}}
  export LFS_USER=${LFS_USER:-${DEFAULT_LFS_USER}}
  export LFS_PARTITION=${LFS_PARTITION:-${DEFAULT_LFS_PARTITION}}
  export LFS=${LFS:-${DEFAULT_LFS}}
  export LFS_SOURCES=${LFS}/sources
  export LFS_TOOLS=${LFS}/tools
  export LFS_CONFIG_SITE=$LFS/usr/share/config.site
  export LFS_DEBUG=${LFS_DEBUG:-${DEFAULT_LFS_DEBUG}}
  export LFS_LOG_DIR=${LFS_LOG_DIR:-${DEFAULT_LFS_LOG_DIR}}
  LFS_TARGET="$(uname -m)-lfs-linux-gnu"
  export LFS_TARGET
  export PATH=$LFS/tools/bin:$PATH
}

read_set_env_params () {
  while [[ $# -gt 0 ]]; do
    KEY=$1
    case $KEY in
      --lfs-user)
        LFS_USER=$2
        shift
        shift
        ;;

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

      --lfs-log-dir)
        LFS_LOG_DIR=$2
        shift
        shift
        ;;

      --debug)
        LFS_DEBUG=true
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
  unset LFS_GROUP
  unset LFS_USER
  unset LFS_PARTITION
  unset LFS
  unset LFS_SOURCES
  unset LFS_TOOLS
  unset LFS_CONFIG_SITE
  unset LFS_LOG_DIR
  unset LFS_TARGET
  unset LFS_DEBUG
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
    show_env
    ;;

  unset)
    unset_env
    show_env
    ;;

  help|*)
    help
    ;;
esac
