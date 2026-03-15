#!/bin/sh
set -ex

SITE_LISP="$OUTPUT_DIR/usr/share/emacs/site-lisp"
mkdir -p "$SITE_LISP"

# Install each elisp package into its own directory under site-lisp
install_pkg() {
  local name="$1"
  local src_dir="$2"
  local dest="$SITE_LISP/$name"
  mkdir -p "$dest"
  cp "$src_dir"/*.el "$dest/" 2>/dev/null || true
  # Some packages keep .el files in lisp/ subdirectory
  if [ -d "$src_dir/lisp" ]; then
    mkdir -p "$dest/lisp"
    cp "$src_dir/lisp/"*.el "$dest/lisp/" 2>/dev/null || true
  fi
}

# Completion framework
install_pkg vertico vertico-2.8
install_pkg orderless orderless-1.6
install_pkg marginalia marginalia-2.10
install_pkg consult consult-3.4
install_pkg corfu corfu-2.9

# Which-key
install_pkg which-key emacs-which-key-3.6.0

# Magit dependencies (must be installed before magit)
install_pkg compat compat-30.1.0.1
install_pkg dash dash.el-2.20.0
install_pkg transient transient-0.8.4/lisp
install_pkg with-editor with-editor-3.4.9/lisp

# Magit itself
install_pkg magit magit-4.1.3/lisp

# Extra modes
install_pkg markdown-mode markdown-mode-2.8
install_pkg yaml-mode yaml-mode-0.0.13
install_pkg dockerfile-mode dockerfile-mode-1.7
install_pkg nickel-mode nickel-mode-e2dcd6cf66d9b5bcde3e3cd69efe053f73b081ab

# Build load-path arguments for byte-compilation
LOAD_PATH=""
for dir in "$SITE_LISP"/*/; do
  LOAD_PATH="$LOAD_PATH -L $dir"
  if [ -d "${dir}lisp" ]; then
    LOAD_PATH="$LOAD_PATH -L ${dir}lisp"
  fi
done

# Byte-compile all .el files
for dir in "$SITE_LISP"/*/; do
  for el in "$dir"*.el "$dir"lisp/*.el; do
    [ -f "$el" ] || continue
    emacs --batch $LOAD_PATH -f batch-byte-compile "$el" 2>&1 || true
  done
done

# Install default.el
cp default.el "$SITE_LISP/default.el"
emacs --batch $LOAD_PATH -f batch-byte-compile "$SITE_LISP/default.el" 2>&1 || true
