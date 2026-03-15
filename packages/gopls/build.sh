#!/bin/sh
set -ex

export GOROOT=/usr/go
export GONOSUMCHECK=*
export GONOSUMDB=*

cd gopls

go build -o $OUTPUT_DIR/usr/bin/gopls .
