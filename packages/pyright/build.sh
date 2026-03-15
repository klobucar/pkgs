#!/bin/sh
set -ex

npm install -g --prefix=$OUTPUT_DIR/usr pyright@$MINIMAL_ARG_VERSION
