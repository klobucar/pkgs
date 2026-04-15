#!/bin/sh
set -ex

export GOROOT=/usr/go
export GONOSUMCHECK=*
export GONOSUMDB=*
export CGO_ENABLED=0

go build -trimpath -ldflags "-buildid= -w -s -X helm.sh/helm/v4/internal/version.version=v${MINIMAL_ARG_VERSION}" -o helm ./cmd/helm

mkdir -p $OUTPUT_DIR/usr/bin
install -m 755 helm $OUTPUT_DIR/usr/bin/helm
