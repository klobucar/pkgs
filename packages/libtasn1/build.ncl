let { Attrs, BuildSpec, Local, OutputBin, OutputData, OutputLib, Source, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let glibc = import "../glibc/build.ncl" in
let make = import "../make/build.ncl" in
let toolchain = import "../toolchain/build.ncl" in

let version = "4.19.0" in
{
  name = "libtasn1",
  build_deps = [
    { file = "build.sh" } | Local,
    {
      url = "https://ftpmirror.gnu.org/libtasn1/libtasn1-%{version}.tar.gz",
      sha256 = "1613f0ac1cf484d6ec0ce3b8c06d56263cc7242f1c23b30d82d23de345a63f7a",
      extract = true,
      strip_prefix = "libtasn1-%{version}",
    } | Source,
    base,
    make,
    toolchain,
  ],
  runtime_deps = [
    glibc,
  ],

  cmd = "./build.sh",

  outputs = {
    bins = { glob = "usr/bin/asn1*" } | OutputBin,
    libs = { glob = "usr/lib/libtasn1.so*" } | OutputLib,
    includes = { glob = "usr/include/**" } | OutputData,
    pkgconfigs = { glob = "usr/lib/pkgconfig/**" } | OutputData,
  },

  attrs =
    {
      upstream_version = version,
      source_provenance = {
        category = 'GnuProject,
        name = "libtasn1",
      },
    } | Attrs,
} | BuildSpec
