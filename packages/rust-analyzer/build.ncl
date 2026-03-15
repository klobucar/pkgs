let { subsetOf, Attrs, BuildSpec, Local, OutputBin, Source, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let gcc = import "../gcc/build.ncl" in
let glibc = import "../glibc/build.ncl" in
let rust = import "../rust/build.ncl" in
let toolchain = import "../toolchain/build.ncl" in

let version = "2025-03-10" in
{
  name = "rust-analyzer",
  build_deps = [
    { file = "build.sh" } | Local,
    {
      url = "https://github.com/rust-lang/rust-analyzer/archive/refs/tags/%{version}.tar.gz",
      sha256 = "8d495f6a9dfe3f4a6fdf0fcfd05d9c5422857523147cf3698c613acb29568db8",
      extract = true,
      strip_prefix = "rust-analyzer-%{version}",
    } | Source,
    base,
    rust,
    toolchain,
  ],
  runtime_deps = [
    glibc,
    subsetOf gcc ["libgcc", "libstdcpp"],
  ],

  cmd = "./build.sh",

  outputs = {
    rust-analyzer = { glob = "usr/bin/rust-analyzer" } | OutputBin,
  },

  attrs =
    {
      upstream_version = version,
      source_provenance = {
        category = 'GithubRepo,
        owner = "rust-lang",
        repo = "rust-analyzer",
      },
      build_cost_multiple = 3,
    } | Attrs,
} | BuildSpec
