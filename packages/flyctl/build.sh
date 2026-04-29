#!/bin/sh
set -ex

export GOROOT=/usr/go
export CGO_ENABLED=0

BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

go build -trimpath \
  -ldflags "-buildid= -w -s \
    -X 'github.com/superfly/flyctl/internal/buildinfo.buildDate=${BUILD_DATE}' \
    -X 'github.com/superfly/flyctl/internal/buildinfo.buildVersion=${MINIMAL_ARG_VERSION}'" \
  -o bin_flyctl .

mkdir -p $OUTPUT_DIR/usr/bin
install -m 755 bin_flyctl $OUTPUT_DIR/usr/bin/flyctl
ln -s flyctl $OUTPUT_DIR/usr/bin/fly
