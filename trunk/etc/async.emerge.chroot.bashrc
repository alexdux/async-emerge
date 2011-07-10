#!/bin/bash

# async.emerge.chroot.bashrc - RC file for chrooted bash from 'async emerge' toolset
# GPL-2
# version: 1.0
# alexdu@forums.gentoo.org

# get config
#. /etc/async.emerge.conf

. ~/.bashrc

export PS1="$AE_CHROOT_PS1 $PS1"
cd

