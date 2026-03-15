#!/bin/sh
set -ex

export CC=gcc
export LD=gcc
export RUSTFLAGS="-C linker=gcc"

cargo build --release -p nickel-lang-lsp

mkdir -p $OUTPUT_DIR/usr/bin
cp target/release/nls $OUTPUT_DIR/usr/bin/
