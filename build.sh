#!/bin/bash

cat /etc/issue

set -x

#git clone https://github.com/NextThingCo/CHIP-linux

export GIT_ORIGIN=$(git remote -v |head -n1|sed -r -e 's/.*(http(s)?:?\/\/|\w@)[A-Za-z0-9.]*[\/:]([^ ]*).*/\3/g; s/\.git//g')
export GIT_USER=${GIT_ORIGIN%/*}
export GIT_REPO=${GIT_ORIGIN#*/}

export LINUX_SRC=CHIP-linux

export ARCH=arm
export KBUILD_DEBARCH=armhf
export CROSS_COMPILE=arm-linux-gnueabihf-
export KDEB_CHANGELOG_DIST=jessie
export LOCALVERSION=-${GIT_USER}-${GIT_REPO}

export KDEB_PKGVERSION=$(cd $LINUX_SRC; make kernelversion)-$YOUR_VERSION
export DEBFULLNAME="$YOUR_FULLNAME"
export DEBEMAIL="$YOUR_EMAIL"


#  make -j4 deb-pkg
