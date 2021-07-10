#!/bin/bash
# xcc_lkm.sh
# **********************************************************************
# This program is part of the source code released for the book
#  "Linux Kernel Programming"
#  (c) Author: Kaiwan N Billimoria
#  Publisher:  Packt
#  GitHub repository:
#  https://github.com/PacktPublishing/Linux-Kernel-Programming
# **********************************************************************
# Brief Description:
#
# This script generates a Makefile to build the given kernel module (works only
# for simple cases). Currently we support cross-compiling for the ARM-32 and
# PowerPC (64-bit) archs, and 'normal' build for the x86[-64].
name=$(basename "$0")

#--- Global config
# set to 1 for verbose build
VERBOSE=0

# *** IMP! UPDATE as required ***
# Kernel source tree locations for various targets
KSRC_ARM_TARGET=~/rpi_work/kernel_rpi/linux  # the Raspberry Pi kernel src
KSRC_PPC64_TARGET="${HOME}/linux-4.9.1"

# Toolchain prefixes for various targets
ARM_CXX=arm-linux-gnueabi-
PPC_CXX=powerpc64-linux-
#---

usage()
{
 echo "Usage: ${name} name-of-kernel-module-file (without any extension)

 This script generates a Makefile to build the given kernel module (works only
 for simple cases). Once generated, it can also build the kernel module by
 invoking 'make' with ARCH and CROSS_COMPILE set appropriately; we keep the 
 LKM build OFF by default; one can set it ON by updating the variable BUILD_LKM
 to 1.

 To select which architecture (cpu) the kernel module is to be (cross) compiled
 for, pl set the environment variable ARCH=<arch>. Currently, we support (cross)
 compiling for:
  x86[_64] : ARCH=(null)    [default]
  ARM-32   : ARCH=arm
  PPC-64   : ARCH=powerpc

 Eg. ARCH=powerpc ${name} <lkm-name>
 Tip: the build 'verbose' switch is currently ${VERBOSE}; (you can toggle it).

 Obviously, we expect:
 - an installed and working cross compiler toolchain(s)
 - kernel source tree to build against; for the x86[-64], we shall default to
   the running kernel's 'build' folder, for the ARM and PPC-64, we have
   hard-coded paths into the Makefile; please change it as required."
}

[ $# -ne 1 ] && {
 usage
 exit 1
}
[[ "${1}" = *"."* ]] && {
 echo "Usage: ${name} name-of-kernel-module-file ONLY (do NOT put any extension)."
 exit 1
}

if [ "${ARCH}" != "arm" ] && [ "${ARCH}" != "powerpc" ] && [ ! -z "${ARCH}" ] ; then
 echo "[!] ${name}: ARCH has to be either 'arm' or 'powerpc' or NULL (for x86, the default)"
 usage
 exit 1
fi
[ "${ARCH}" = "arm" ] && {
  which ${ARM_CXX}gcc >/dev/null || {
    echo "[!] ARM cross compiler (${ARM_CXX}gcc) not installed (or not in PATH)? Aborting..."
    exit 1
  }
}
[ "${ARCH}" = "powerpc" ] && {
  which ${PPC_CXX}gcc >/dev/null || {
    echo "[!] PowerPC-64 cross compiler (${PPC_CXX}gcc) not installed (or not in PATH)? Aborting..."
    exit 1
  }
}
[ -z "${ARCH}" ] && {    # ${ARCH} == NULL implies x86[-64]
  [ ! -d /lib/modules/"$(uname -r)"/build/ ] && {
    echo "[!] x86[-64]: failed to locate /lib/modules/$(uname -r)/build/.
Package kernel-headers required to be installed? Aborting..."
    exit 1
  }
}

[ -f Makefile ] && cp -f Makefile Makefile.bkp
cat > Makefile << EOF
# Makefile : auto-generated by script ${name}
# For 'Linux Kernel Programming', Kaiwan N Billimoria, Packt
#  [...]/$1
#
# To support cross-compiling for kernel modules:
# For architecture (cpu) 'arch', invoke make as:
# make ARCH=<arch> CROSS_COMPILE=<cross-compiler-prefix>
ifeq (\$(ARCH),arm)
    # **NOTE** Do *UPDATE* 'KDIR' below to point to the ARM Linux kernel
    # source tree on your box
    KDIR ?= ${KSRC_ARM_TARGET}   # the R Pi kernel

else ifeq (\$(ARCH),powerpc)
    # *UPDATE* 'KDIR' below to point to the PPC64 Linux kernel source tree on your box
    KDIR ?= ${KSRC_PPC64_TARGET}
else
    # x86[-64]: 'KDIR' is the Linux kernel source tree (headers) on your box
    KDIR ?= /lib/modules/\$(shell uname -r)/build
endif

PWD	       := \$(shell pwd)
obj-m          += $1.o
EXTRA_CFLAGS   += -DDEBUG
\$(info Building for: KREL=\${KERNELRELEASE} ARCH=\${ARCH} CROSS_COMPILE=\${CROSS_COMPILE} EXTRA_CFLAGS=\${EXTRA_CFLAGS})

all:
	make -C \$(KDIR) M=\$(PWD) modules
install:
	make -C \$(KDIR) M=\$(PWD) modules_install
clean:
	make -C \$(KDIR) M=\$(PWD) clean

# 'cb' target is 'C beautifier'
cb:
	indent -linux *.[ch]
EOF

echo "[+] Makefile generated; verbose=${VERBOSE}"
ls -l Makefile

BUILD_LKM=0   # set to 1 to build it
[ ${BUILD_LKM} -ne 1 ] && {
  echo "${name}: BUILD_LKM setting Off, done"
  exit 0
}

# Ok, lets build it!
echo "[+] make clean"
make clean

if [ "${ARCH}" = "arm" ]; then
  export ARCH=arm; export CROSS_COMPILE=${ARM_CXX}
  echo; echo "[+] ------ ARM build :: make V=${VERBOSE} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}"
  make V=${VERBOSE} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
elif [ "${ARCH}" = "powerpc" ]; then
  export ARCH=powerpc; export CROSS_COMPILE=${PPC_CXX}
  echo; echo "[+] ------ PowerPC64 build :: make V=${VERBOSE} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}"
  make V=${VERBOSE} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
else
  echo; echo "[+] ------ x86[-64] build :: make V=${VERBOSE}"
  make V=${VERBOSE}
fi

echo
if [ ! -f "$1".ko ] ; then
  echo "[!] ${name} : Failed; $1.ko not generated, aborting"
  exit 1
else
  file "$1".ko
  ls -l "$1".ko
fi
exit 0
