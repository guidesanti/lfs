#!/bin/bash

source ./utils.sh

export LC_ALL=C

# Print some links
MYSH=$(readlink -f /bin/sh)
printf $MYSH | grep -q bash || log_error "/bin/sh does not point to bash"
printf "%-20s -> %s\n" "/bin/sh" "${MYSH}"
unset MYSH

if [ -h /usr/bin/yacc ]; then
  printf "%-20s -> %s\n" "/usr/bin/yacc" "$(readlink -f /usr/bin/yacc)"
fi
if [ -h /usr/bin/awk ]; then
  printf "%-20s -> %s\n" "/usr/bin/awk" "$(readlink -f /usr/bin/awk)"
fi

# Print version of tools
printf "%-20s %s\n" "system" "$(cat /proc/version)"
printf "%-20s %s\n" "bash" "$(bash --version | head -n1 | cut -d" " -f2-4)"
printf "%-20s %s\n" "binutils" "$(ld --version | head -n1 | cut -d" " -f3-)"
printf "%-20s %s\n" "bison" "$(bison --version | head -n1)"
if [ -x /usr/bin/yacc ]; then
  printf "%-20s %s\n" "yacc" "$(/usr/bin/yacc --version | head -n1)"
else
  log_error "yacc not found"
fi
printf "%-20s %s\n" "bzip2" "$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-)"
printf "%-20s %s\n" "coreutils" "$(chown --version | head -n1 | cut -d")" -f2)"
printf "%-20s %s\n" "diff" "$(diff --version | head -n1)"
printf "%-20s %s\n" "find" "$(find --version | head -n1)"
printf "%-20s %s\n" "gawk" "$(gawk --version | head -n1)"
if [ -x /usr/bin/awk ]; then
  printf "%-20s %s\n" "awk" "$(/usr/bin/awk --version | head -n1)"
else
  log_error "awk not found"
fi
printf "%-20s %s\n" "gcc" "$(gcc --version | head -n1)"
printf "%-20s %s\n" "g++" "$(g++ --version | head -n1)"
printf "%-20s %s\n" "glibc" "$(ldd --version | head -n1 | cut -d" " -f2-)"
printf "%-20s %s\n" "grep" "$(grep --version | head -n1)"
printf "%-20s %s\n" "gzip" "$(gzip --version | head -n1)"
printf "%-20s %s\n" "m4" "$(m4 --version | head -n1)"
printf "%-20s %s\n" "make" "$(make --version | head -n1)"
printf "%-20s %s\n" "patch" "$(patch --version | head -n1)"
printf "%-20s %s\n" "perl" "$(perl -V:version)"
printf "%-20s %s\n" "python3" "$(python3 --version)"
printf "%-20s %s\n" "sed" "$(sed --version | head -n1)"
printf "%-20s %s\n" "tar" "$(tar --version | head -n1)"
printf "%-20s %s\n" "texinfo" "$(makeinfo --version | head -n1)"
printf "%-20s %s\n" "xz" "$(xz --version | head -n1)"

# Test g++ compilation
echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]; then
  echo "g++ compilation OK";
else
  echo "g++ compilation failed"; fi
rm -f dummy.c dummy
