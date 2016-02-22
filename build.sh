#!/bin/bash

function echo_var() {
  eval echo "$1=\$$1"
}

set -x

export BUILD="${TRAVIS_BUILD_NUMBER}"

export GIT_ORIGIN=$(git remote -v |head -n1|sed -r -e 's/.*(http(s)?:?\/\/|\w@)[A-Za-z0-9.]*[\/:]([^ ]*).*/\3/g; s/\.git//g')
export GIT_USER=${GIT_ORIGIN%/*}
export GIT_REPO=${GIT_ORIGIN#*/}

#install 32bit compatibility layers for Linaro Tool Chain:
sudo apt-get -y install libc6-i386 lib32stdc++6 lib32z1

#install Linaro Tool Chain:
wget -c https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz
tar xf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz
#export CC="${PWD}/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-"
#export PATH="${PWD}/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin":"${PWD}/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/arm-linux-gnueabihf/bin/":"${PATH}"
export PATH="${PWD}/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin":"${PATH}"

#checkout Linux
export LINUX_SRC="${PWD}/CHIP-linux"
export LINUX_BRANCH=debian/4.3.0-5
git clone -b "${LINUX_BRANCH}" --single-branch --depth 1 https://github.com/NextThingCo/CHIP-linux

# Build Linux .deb
cd CHIP-linux

export ARCH=arm
export KBUILD_DEBARCH=armhf
export CROSS_COMPILE=arm-linux-gnueabihf-
export KDEB_CHANGELOG_DIST=jessie
export LOCALVERSION=-${GIT_USER}-${GIT_REPO}

export KDEB_PKGVERSION=$(cd $LINUX_SRC; make kernelversion)-${BUILD}
export DEBFULLNAME="${GIT_USER}"
export DEBEMAIL="${GIT_USER}@github.com"

make -j4 deb-pkg
