#!/bin/sh
set -ex

npm install -g --prefix=$OUTPUT_DIR/usr bash-language-server@$MINIMAL_ARG_VERSION
