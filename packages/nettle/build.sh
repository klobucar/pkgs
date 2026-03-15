#!/bin/sh
set -ex

case $(uname -m) in
  x86_64)  MARCH="-march=x86-64-v3" ;;
  aarch64) MARCH="-march=armv8-a" ;;
  *)       MARCH="" ;;
esac
export CFLAGS="$MARCH -O2 -pipe -std=gnu17"
export CXXFLAGS="$MARCH -O2 -pipe -std=gnu++17"

./configure --prefix=/usr --disable-static --enable-shared
make -j$(nproc)
make DESTDIR=$OUTPUT_DIR install
