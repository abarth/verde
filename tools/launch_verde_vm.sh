#!/bin/bash

VERDE_ROOT=$(dirname $(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]}))))

set -ex

sudo xl create -c "$VERDE_ROOT/verde/xen/verde.cfg"
