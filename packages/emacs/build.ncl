let { subsetOf, Attrs, BuildSpec, Local, OutputBin, OutputData, Source, .. } = import "minimal.ncl" in
let autoconf = import "../autoconf/build.ncl" in
let base = import "../base/build.ncl" in
let gcc = import "../gcc/build.ncl" in
let glibc = import "../glibc/build.ncl" in
let gmp = import "../gmp/build.ncl" in
let gnutls = import "../gnutls/build.ncl" in
let jansson = import "../jansson/build.ncl" in
let libxml2 = import "../libxml2/build.ncl" in
let make = import "../make/build.ncl" in
let ncurses = import "../ncurses/build.ncl" in
let pkgconf = import "../pkgconf/build.ncl" in
let toolchain = import "../toolchain/build.ncl" in
let tree-sitter = import "../tree-sitter/build.ncl" in
let zlib = import "../zlib/build.ncl" in
let version = "30.1" in
{
  name = "emacs",
  build_deps = [
    { file = "build.sh" } | Local,
    {
      url = "https://ftpmirror.gnu.org/emacs/emacs-%{version}.tar.xz",
      sha256 = "6ccac1ae76e6af93c6de1df175e8eb406767c23da3dd2a16aa67e3124a6f138f",
      extract = true,
      strip_prefix = "emacs-%{version}",
    } | Source,
    autoconf,
    base,
    make,
    pkgconf,
    toolchain,
  ],
  runtime_deps = [
    glibc,
    gmp,
    gnutls,
    jansson,
    libxml2,
    ncurses,
    subsetOf gcc ["libgcc"],
    tree-sitter,
    zlib,
  ],

  cmd = "./build.sh",

  outputs = {
    bins = { glob = "usr/bin/*" } | OutputBin,
    libexec = { glob = "usr/libexec/emacs/**", allow_executable = true } | OutputData,
    share = { glob = "usr/share/emacs/**", allow_executable = true } | OutputData,
  },

  attrs =
    {
      upstream_version = version,
      source_provenance = {
        category = 'GnuProject,
        name = "emacs",
      },
      build_cost_multiple = 3,
    } | Attrs,
} | BuildSpec
