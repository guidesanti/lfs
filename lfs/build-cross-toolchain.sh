#!/bin/bash

source ./utils.sh
source ./common.sh

check_environment
check_lfs_mount_point
check_lfs_user

# ---------------------------------------------------------------------------------------- #
# Binutils-2.37 - Pass 1
# ---------------------------------------------------------------------------------------- #
cd "${LFS_SOURCES}"
tar -xf binutils-2.37.tar.xz
cd binutils-2.37
mkdir -v build
cd build
../configure --prefix=$LFS_TOOLS \
  --with-sysroot=$LFS \
  --target=$LFS_TARGET \
  --disable-nls \
  --disable-werror
make
make install -j1
cd "${LFS_SOURCES}"
rm -rf binutils-2.37

# ---------------------------------------------------------------------------------------- #
# GCC-11.2.0 - Pass 1
# ---------------------------------------------------------------------------------------- #
cd "${LFS_SOURCES}"
tar -xf gcc-11.2.0.tar.xz
cd gcc-11.2.0
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
cd build

../configure \
  --target="${LFS_TARGET}" \
  --prefix="${LFS_TOOLS}" \
  --with-glibc-version=2.11 \
  --with-sysroot="${LFS}" \
  --with-newlib \
  --without-headers \
  --enable-initfini-array \
  --disable-nls \
  --disable-shared \
  --disable-multilib \
  --disable-decimal-float \
  --disable-threads \
  --disable-libatomic \
  --disable-libgomp \
  --disable-libquadmath \
  --disable-libssp \
  --disable-libvtv \
  --disable-libstdcxx \
  --enable-languages=c,c++
make
make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $(${LFS_TARGET}-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
cd "${LFS_SOURCES}"
rm -rf gcc-11.2.0

# ---------------------------------------------------------------------------------------- #
# Linux-5.13.12 API Headers
# ---------------------------------------------------------------------------------------- #
cd "${LFS_SOURCES}"
tar -xf linux-5.13.12.tar.xz
cd linux-5.13.12

make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include "${LFS}"/usr

cd "${LFS_SOURCES}"
rm -rf linux-5.13.12

# ---------------------------------------------------------------------------------------- #
# Glibc-2.34
# ---------------------------------------------------------------------------------------- #
cd "${LFS_SOURCES}"
tar -xf glibc-2.34.tar.xz
cd glibc-2.34

case $(uname -m) in
  i?86)
    ln -sfv ld-linux.so.2 "${LFS}"/lib/ld-lsb.so.3
    ;;

  x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 "${LFS}"/lib64
    ln -sfv ../lib/ld-linux-x86-64.so.2 "${LFS}"/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i ../glibc-2.34-fhs-1.patch

mkdir -v build
cd build
echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr \
  --host="${LFS_TARGET}" \
  --build="$(../scripts/config.guess)" \
  --enable-kernel=3.2 \
  --with-headers="${LFS}"/usr/include \
  libc_cv_slibdir=/usr/lib
make
make DESTDIR="${LFS}" install
sed '/RTLDLIST=/s@/usr@@g' -i "${LFS}"/usr/bin/ldd

cd "${LFS_SOURCES}"
rm -rf glibc-2.34

# ---------------------------------------------------------------------------------------- #
# Sanity check
# ---------------------------------------------------------------------------------------- #
echo 'int main(){}' > dummy.c
"${LFS_TARGET}"-gcc dummy.c || fail "Sanity check failed"
readelf -l a.out | grep '/ld-linux'
rm -v dummy.c a.out

# ---------------------------------------------------------------------------------------- #
# Finalize installation of the limits.h header
# ---------------------------------------------------------------------------------------- #
${LFS_TOOLS}/libexec/gcc/${LFS_TARGET}/11.2.0/install-tools/mkheaders

# ---------------------------------------------------------------------------------------- #
# Libstdc++ from GCC-11.2.0, Pass 1
# ---------------------------------------------------------------------------------------- #
cd "${LFS_SOURCES}"
tar -xf gcc-11.2.0.tar.xz
cd gcc-11.2.0

mkdir -v build
cd build

../libstdc++-v3/configure \
  --host="${LFS_TARGET}" \
  --build="$(../config.guess)" \
  --prefix=/usr \
  --disable-multilib \
  --disable-nls \
  --disable-libstdcxx-pch \
  --with-gxx-include-dir=/tools/"${LFS_TARGET}"/include/c++/11.2.0
make
make DESTDIR="${LFS}" install

cd "${LFS_SOURCES}"
rm -rf gcc-11.2.0
