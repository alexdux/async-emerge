#!/bin/sh

# Script to build, install & conf linux kernel
# V1.1 Ald Sun 02 Feb 2014 01:42:10 PM MSK

KRNVER=`ls -l /usr/src/linux | cut -f2 -d'>'`
# Welcome info
echo '*******************************************'
echo '*** Start Building Kernel:'${KRNVER}' ***'
echo '*******************************************'

# Get compl/make opts
echo '>>> confgigure with /etc/make.conf'
. /etc/make.conf

# Go to linux dir
OLDWD=`pwd`
cd linux
echo '>>> go to '`pwd`

# Play with .config
echo '>>> configure the kernel:'
if [ -e .config ]; then
    echo '>>>   run menuconfig...'
    make ${MAKEOPTS} menuconfig
else
    echo '>>>   run oldconfig...'
    cp -v ../.config .
    make ${MAKEOPTS} oldconfig
fi
echo '>>> saving config'
cp -fpv .config ..

# Care /boot
echo '>>> mounting /boot'
mount /boot
rm -v /boot/*old

# Build & install the kernel and refresh frub conf
echo '>>> rebuild extra modules against the kernel...'
make ${MAKEOPTS} modules_prepare
temerge @module-rebuild

echo '>>> build & install kernel'
make ${MAKEOPTS} && make install modules_install

echo '>>> reconfig the grub loader'
grub-mkconfig -o /boot/grub/grub.cfg

# Go to orig dir
echo '>>> restore dir to: '${OLDWD}
cd $OLDWD

# Save .configs
OLDCFGS='old_configs'
echo '>>> Save all found configs to: '${OLDCFGS}
mkdir -pv ${OLDCFGS}
for i in linux-*; do
    [ -e ${i}/.config ] && \
	cp -fpv ${i}/.config ${OLDCFGS}/.config-${i}
done

# extra stuff
if [ -e extra_kernel.sh ]; then
	echo '>>> extra stuff running:'
	. ./extra_kernel.sh
fi

# Bye info
echo '******************************************'
echo '*** Done Building Kernel:'${KRNVER}' ***'
echo '******************************************'
