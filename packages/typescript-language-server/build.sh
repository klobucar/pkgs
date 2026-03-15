#!/bin/sh
set -ex

npm install -g --prefix=$OUTPUT_DIR/usr \
  typescript-language-server@$MINIMAL_ARG_VERSION \
  typescript
