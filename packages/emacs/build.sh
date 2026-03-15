#!/bin/sh
set -ex

case $(uname -m) in
  x86_64)  MARCH="-march=x86-64-v3" ;;
  aarch64) MARCH="-march=armv8-a" ;;
  *)       MARCH="" ;;
esac
export CFLAGS="$MARCH -O2 -pipe -std=gnu17"
export CXXFLAGS="$MARCH -O2 -pipe -std=gnu++17"

./configure --prefix=/usr \
  --without-all \
  --without-x \
  --without-ns \
  --with-gnutls \
  --with-xml2 \
  --with-zlib \
  --with-tree-sitter \
  --with-modules \
  --with-threads \
  --with-file-notification=inotify \
  --without-compress-install \
  MAKEINFO=true

make MAKEINFO=true -j$(nproc)
make MAKEINFO=true DESTDIR=$OUTPUT_DIR install
