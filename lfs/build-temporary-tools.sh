#!/bin/bash

source ./utils.sh
source ./common.sh

check_environment
check_lfs_mount_point
check_lfs_user

echo "Changing to LFS sources directory '${LFS_SOURCES}'"
pushd "${LFS_SOURCES}" || return 1

# ---------------------------------------------------------------------------------------- #
# M4-1.4.19
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=m4-1.4.19
#PACK_FILE=m4-1.4.19.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}" \
#  --build="$(build-aux/config.guess)"
#make
#make DESTDIR=${LFS} install
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Ncurses-6.2
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=ncurses-6.2
#PACK_FILE=ncurses-6.2.tar.gz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#sed -i s/mawk// configure
#mkdir build
#pushd build || return 1
#../configure
#make -C include
#make -C progs tic
#popd || return 1
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}"
#  --build=$(./config.guess) \
#  --mandir=/usr/share/man \
#  --with-manpage-format=normal \
#  --with-shared \
#  --without-debug \
#  --without-ada \
#  --without-normal \
#  --enable-widec
#make
#make DESTDIR=${LFS} TIC_PATH=$(pwd)/build/progs/tic install
#echo "INPUT(-lncursesw)" > "${LFS}/usr/lib/libncurses.so"
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Bash-5.1.8
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=bash-5.1.8
#PACK_FILE=bash-5.1.8.tar.gz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#./configure --prefix=/usr \
#  --build="$(support/config.guess)" \
#  --host="${LFS_TARGET}" \
#  --without-bash-malloc
#make
#make DESTDIR=${LFS} install
#ln -sv bash "${LFS}/bin/sh"
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Coreutils-8.32
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=coreutils-8.32
#PACK_FILE=coreutils-8.32.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}" \
#  --build=$(build-aux/config.guess) \
#  --enable-install-program=hostname \
#  --enable-no-install-program=kill,uptime
#make
#make DESTDIR="${LFS}" install
#
#mv -v "${LFS}"/usr/bin/chroot "${LFS}"/usr/sbin
#mkdir -pv "${LFS}"/usr/share/man/man8
#mv -v "${LFS}"/usr/share/man/man1/chroot.1 "${LFS}"/usr/share/man/man8/chroot.8
#sed -i 's/"1"/"8"/' "${LFS}"/usr/share/man/man8/chroot.8
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Diffutils-3.8
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=diffutils-3.8
#PACK_FILE=diffutils-3.8.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr --host="${LFS_TARGET}"
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# File-5.40
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=file-5.40
#PACK_FILE=file-5.40.tar.gz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#mkdir build
#pushd build || return 1
#../configure --disable-bzlib \
#  --disable-libseccomp \
#  --disable-xzlib \
#  --disable-zlib
#make
#popd || return 1
#
#./configure --prefix=/usr --host="${LFS_TARGET}" --build=$(./config.guess)
#make FILE_COMPILE="$(pwd)"/build/src/file
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Findutils-4.8.0
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=findutils-4.8.0
#PACK_FILE=findutils-4.8.0.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --localstatedir=/var/lib/locate \
#  --host="${LFS_TARGET}" \
#  --build=$(build-aux/config.guess)
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Gawk-5.1.0
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=gawk-5.1.0
#PACK_FILE=gawk-5.1.0.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#sed -i 's/extras//' Makefile.in
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}" \
#  --build=$(./config.guess)
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Grep-3.7
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=grep-3.7
#PACK_FILE=grep-3.7.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}"
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Gzip-1.10
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=gzip-1.10
#PACK_FILE=gzip-1.10.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}"
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Make-4.3
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=make-4.3
#PACK_FILE=make-4.3.tar.gz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --without-guile \
#  --host="${LFS_TARGET}" \
#  --build=$(build-aux/config.guess)
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Patch-2.7.6
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=patch-2.7.6
#PACK_FILE=patch-2.7.6.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}" \
#  --build=$(build-aux/config.guess)
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Sed-4.8
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=sed-4.8
#PACK_FILE=sed-4.8.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}"
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Tar-1.34
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=tar-1.34
#PACK_FILE=tar-1.34.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}" \
#  --build=$(build-aux/config.guess)
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Xz-5.2.5
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=xz-5.2.5
#PACK_FILE=xz-5.2.5.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#./configure --prefix=/usr \
#  --host="${LFS_TARGET}" \
#  --build=$(build-aux/config.guess) \
#  --disable-static \
#  --docdir=/usr/share/doc/xz-5.2.5
#make
#make DESTDIR="${LFS}" install
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# Binutils-2.37 - Pass 2
# ---------------------------------------------------------------------------------------- #
#PACK_NAME=binutils-2.37
#PACK_FILE=binutils-2.37.tar.xz
#tar -xf ${PACK_FILE}
#pushd ${PACK_NAME} || return 1
#
#mkdir -v build
#pushd build || return 1
#../configure --prefix=/usr \
#  --build=$(../config.guess) \
#  --host="${LFS_TARGET}" \
#  --disable-nls \
#  --enable-shared \
#  --disable-werror \
#  --enable-64-bit-bfd
#make
#make DESTDIR="${LFS}" install -j1
#install -vm755 libctf/.libs/libctf.so.0.0.0 "${LFS}"/usr/lib
#popd || return 1
#
#popd || return 1
#rm -rf ${PACK_NAME}
#printf "%-100s" "Building ${PACK_NAME}"
#ok

# ---------------------------------------------------------------------------------------- #
# GCC-11.2.0 - Pass 2
# ---------------------------------------------------------------------------------------- #
PACK_NAME=gcc-11.2.0
PACK_FILE=gcc-11.2.0.tar.xz
tar -xf ${PACK_FILE}
pushd ${PACK_NAME} || return 1

tar -xf ../mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ../mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
    ;;
esac

mkdir -v build
pushd build || return 1
mkdir -pv "${LFS_TARGET}"/libgcc
ln -s ../../../libgcc/gthr-posix.h "${LFS_TARGET}"/libgcc/gthr-default.h
../configure --build=$(../config.guess) \
  --host="${LFS_TARGET}" \
  --prefix=/usr \
  CC_FOR_TARGET="${LFS_TARGET}"-gcc \
  --with-build-sysroot="${LFS}" \
  --enable-initfini-array \
  --disable-nls \
  --disable-multilib \
  --disable-decimal-float \
  --disable-libatomic \
  --disable-libgomp \
  --disable-libquadmath \
  --disable-libssp \
  --disable-libvtv \
  --disable-libstdcxx \
  --enable-languages=c,c++
make
make DESTDIR="${LFS}" install
ln -sv gcc "${LFS}"/usr/bin/cc
popd || return 1

popd || return 1
rm -rf ${PACK_NAME}
printf "%-100s" "Building ${PACK_NAME}"
ok

echo "Returning back to original directory"
popd || return 1
