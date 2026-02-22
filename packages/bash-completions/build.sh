#!/bin/sh
set -e

tar -xfo "bash-completion-${MINIMAL_ARG_VERSION}.tar.xz"
cd "bash-completion-${MINIMAL_ARG_VERSION}"

./configure --prefix=/usr --sysconfdir=/etc
make
make DESTDIR="$OUTPUT_DIR" install
