#!/bin/sh
set -ex

export CC=gcc
export LD=gcc
export RUSTFLAGS="-C linker=gcc"

cargo build --release -p nickel-lang-cli

mkdir -p $OUTPUT_DIR/usr/bin
cp target/release/nickel $OUTPUT_DIR/usr/bin/
