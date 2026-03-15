#!/bin/sh
set -ex

tar -xof shellcheck-v${MINIMAL_ARG_VERSION}.linux.x86_64.tar.xz

mkdir -p $OUTPUT_DIR/usr/bin
install -m 755 shellcheck-v${MINIMAL_ARG_VERSION}/shellcheck $OUTPUT_DIR/usr/bin/shellcheck
