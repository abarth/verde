#!/bin/bash
VERDE_ROOT=$(dirname $(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]}))))

mkdir -p "$VERDE_ROOT/out"

echo "Building busybox..."
BUSYBOX_OUT="$VERDE_ROOT/out/busybox"
mkdir -p "$BUSYBOX_OUT"
(
  cd "$VERDE_ROOT/busybox";
  make "O=$BUSYBOX_OUT" defconfig
)
cp "$VERDE_ROOT/verde/configs/busybox.config" "$BUSYBOX_OUT/.config"
(
  cd "$BUSYBOX_OUT" ;
  make -j2
  make install
)

echo "Building musl..."
MUSL_OUT="$VERDE_ROOT/out/musl"
mkdir -p "$MUSL_OUT"
(
  cd "$VERDE_ROOT/musl" ;
  ./configure "--prefix=$MUSL_OUT" ;
  make -j2 ;
  make install
)

echo "Building rootfs..."
ROOTFS_DIR="$VERDE_ROOT/out/rootfs"
mkdir -p "$ROOTFS_DIR"
BOOT_DIR="$VERDE_ROOT/out/boot"
mkdir -p "$BOOT_DIR"
(
  cd "$ROOTFS_DIR" ;
  mkdir -pv {bin,sbin,etc,proc,sys,ssd,usr/{bin,sbin}} ;
  cp -av $BUSYBOX_OUT/_install/* $VERDE_ROOT/verde/rootfs/* . ;
  find . -print0 | cpio --null -ov --format=newc | gzip -9 > "$BOOT_DIR/initrd.gz"
)
