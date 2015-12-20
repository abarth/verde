#!/bin/bash

VERDE_ROOT=$(dirname $(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]}))))

set -ex

(cd $VERDE_ROOT/linux && make -j2 drivers/staging/verde/verde_ipc.ko)
(cd $VERDE_ROOT/verde/userland/hello && make)
(cd $VERDE_ROOT/verde/userland/ipc_testbed && make)

sudo mount -n /dev/deepzen-vg/lv_verde $VERDE_ROOT/out/ssd

sudo cp $VERDE_ROOT/linux/drivers/staging/verde/verde_ipc.ko $VERDE_ROOT/out/ssd/home
sudo cp $VERDE_ROOT/verde/userland/hello/hello $VERDE_ROOT/out/ssd/home
sudo cp $VERDE_ROOT/verde/userland/ipc_testbed/ipc_testbed $VERDE_ROOT/out/ssd/home

sudo umount $VERDE_ROOT/out/ssd
