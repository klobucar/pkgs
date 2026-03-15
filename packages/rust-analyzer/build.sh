#!/bin/sh
set -ex

export CC=gcc
export LD=gcc
export RUSTFLAGS="-C linker=gcc"

cargo build --release -p rust-analyzer

mkdir -p $OUTPUT_DIR/usr/bin
cp target/release/rust-analyzer $OUTPUT_DIR/usr/bin/
