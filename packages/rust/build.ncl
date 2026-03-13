let { subsetOf, Attrs, BuildSpec, Local, Needs, OutputBin, OutputData, OutputLib, Source, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let cmake = import "../cmake/build.ncl" in
let curl = import "../curl/build.ncl" in
let llvm = import "../llvm/build.ncl" in
let openssl = import "../openssl/build.ncl" in
let pkgconf = import "../pkgconf/build.ncl" in
let python = import "../python/build.ncl" in
let sqlite = import "../sqlite/build.ncl" in
let libffi = import "../libffi/build.ncl" in
let toolchain = import "../toolchain/build.ncl" in
let gcc = import "../gcc/build.ncl" in

let version = "1.94.0" in
{
  name = "rust",
  build_deps = [
    { file = "bootstrap.toml" } | Local,
    { file = "build.sh" } | Local,
    {
      url = "gs://minimal-staging-archives/rustc-%{version}-src.tar.xz",
      sha256 = "0b53ae34f5c0c3612cfe1de139f9167a018cd5737bc2205664fd69ba9b25f600",
      extract = true,
      strip_prefix = "rustc-%{version}-src",
    } | Source,
    base,
    cmake,
    curl,
    pkgconf,
    python,
    toolchain,
  ],
  runtime_deps = [
    libffi,
    llvm,
    openssl,
    sqlite,
    subsetOf gcc ["libgcc", "libstdcpp"],
  ],
  needs =
    {
      dns = {},
      internet = {},
    } | Needs,

  cmd = "./build.sh",
  outputs = {
    bins = { glob = "usr/bin/*" } | OutputBin,

    librustc_driver = { glob = "usr/lib/librustc_driver*.so" } | OutputLib,
    rustlib_src = { glob = "usr/lib/rustlib/src/**" } | OutputData,
    rustlib_etc = { glob = "usr/lib/rustlib/etc/**" } | OutputData,
    rustlib_bins = { glob = "usr/lib/rustlib/*/bin/**" } | OutputBin,
    rustlib_libs = { glob = "usr/lib/rustlib/*/lib/*.{so*,rlib}" } | OutputLib,

    rust-analyzer-proc-macro-srv = { glob = "usr/libexec/rust-analyzer-proc-macro-srv" } | OutputBin,

    mans = { glob = "usr/share/man/**" } | OutputData,
  },

  attrs =
    {
      upstream_version = version,
      source_provenance = {
        category = 'GithubRepo,
        owner = "rust-lang",
        repo = "rust",
      },
      env_state_wiring = {
        env_var = "CARGO_HOME",
        prefix = "cargo",
      },
      build_cost_multiple = 3,
    } | Attrs,
} | BuildSpec
