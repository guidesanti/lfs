#!/bin/bash

source ./utils.sh

LOG_FILE=/tmp/lfs/create-lfs-user.log
PASSWORD=
LFS_GROUP=lfs
LFS_USER=lfs

help () {
  printf "SYNOPSIS\n"
  printf "%5s%s\n" "" "create-lfs-user.sh [OPTIONS]"
  printf "\n"

  printf "OPTIONS:\n"
  printf "%5s%-20s %s\n" "" "--help" "Prints this help"
  printf "%5s%-20s %s\n" "" "--group <GROUP>" "Group name, default is '${LFS_GROUP}'"
  printf "%5s%-20s %s\n" "" "--user <USER>" "User name, default is '${LFS_USER}'"
  printf "%5s%-20s %s\n" "" "--password <PASSWORD>" "User password, default is to create user without password"
  printf "\n"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  KEY=$1
  case $KEY in
    --group)
      LFS_GROUP=$2
      shift
      shift
      ;;

    --user)
      LFS_USER=$2
      shift
      shift
      ;;

    --password)
      PASSWORD=$2
      shift
      shift
      ;;

    --help|*)
      help
      exit 0
      ;;
  esac
done

LFS_HOME=/home/${LFS_USER}

printf "Creating LFS group and user:\n"
printf "LFS group: %s\n" "${LFS_GROUP}"
printf "LFS user: %s\n" "${LFS_USER}"
printf "LFS user password: %s\n" "${NO_PASSWORD}"
printf "LFS user home: %s\n" "${LFS_HOME}"
read -r -p "Is that information correct (y/n)? " ANSWER
if [[ ${ANSWER} == "n" ]]; then
  printf "Aborted\n"
  exit 0
fi

sudo -v

# Create LFS group
printf "%-50s" "LFS group"
GROUP_EXIST=$(cat < /etc/group | grep "${LFS_GROUP}" | cut -d ':' -f 1)
if [[ -z "${GROUP_EXIST}" ]]; then
  if ! sudo groupadd "${LFS_USER}" &>> ${LOG_FILE}; then
    fail
  fi
fi
ok

# Create LFS user
printf "%-50s" "LFS user"
USER_EXIST=$(cat < /etc/passwd | grep "${LFS_USER}" | cut -d ':' -f 1)
if [[ -z "${USER_EXIST}" ]]; then
  sudo useradd -s /bin/bash -g "${LFS_GROUP}" -m -k /dev/null "${LFS_USER}" &>> ${LOG_FILE} || fail
  if [[ -z "${PASSWORD}" ]]; then
    sudo passwd -d "${LFS_USER}" &>> ${LOG_FILE} || fail
  else
    echo -e "$PASSWORD\n$PASSWORD" | sudo passwd lfs &>> ${LOG_FILE} || fail
  fi

  # Add LFS user to sudo
  sudo usermod -aG sudo ${LFS_USER} &>> ${LOG_FILE} || fail

  # create .bash_profile
  sudo -H -u "${LFS_USER}" bash -c "cat > ~/.bash_profile << \"EOF\"
exec env -i HOME=$LFS_HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF" &>> ${LOG_FILE} || fail

  # Create .bashrc
  sudo -H -u "${LFS_USER}" bash -c "cat > ~/.bashrc << \"EOF\"
set +h
umask 022
LC_ALL=POSIX
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
export LC_ALL PATH
EOF" &>> ${LOG_FILE} || fail
fi
ok

printf "Done\n"
