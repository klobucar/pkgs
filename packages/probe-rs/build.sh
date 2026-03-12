#!/bin/bash
set -euo pipefail

export CC=gcc
export LD=gcc
export RUSTFLAGS="-C linker=gcc"

cargo build --release -p probe-rs-tools

mkdir -p $OUTPUT_DIR/usr/bin
cp target/release/probe-rs $OUTPUT_DIR/usr/bin/
cp target/release/cargo-flash $OUTPUT_DIR/usr/bin/
cp target/release/cargo-embed $OUTPUT_DIR/usr/bin/
