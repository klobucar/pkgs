let { BuildSpec, Local, OutputBin, OutputData, OutputLib, Source, Test, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let toolchain = import "../toolchain/build.ncl" in
let bison = import "../bison/build.ncl" in
let flex = import "../flex/build.ncl" in
let make = import "../make/build.ncl" in

let glibc = import "../glibc/build.ncl" in
let ncurses = import "../ncurses/build.ncl" in
let readline = import "../readline/build.ncl" in

let version = "45.2" in
{
  name = "ngspice",
  build_deps = [
    { file = "build.sh" } | Local,
    {
      url = "gs://minimal-staging-archives/ngspice-%{version}.tar.gz",
      sha256 = "ba8345f4c3774714c10f33d7da850d361cec7d14b3a295d0dc9fd96f7423812d",
      extract = true,
      strip_prefix = "ngspice-%{version}",
    } | Source,
    base,
    bison,
    flex,
    make,
    toolchain,
  ],
  runtime_deps = [
    glibc,
    ncurses,
    readline,
  ],

  cmd = "./build.sh",
  build_args = {
    include version,
  },

  outputs = {
    bins = { glob = "usr/bin/*" } | OutputBin,
    codemodels = { glob = "usr/lib/ngspice/*.cm" } | OutputData,
    scripts = { glob = "usr/share/ngspice/scripts/**" } | OutputData,
    man = { glob = "usr/share/man/**/*" } | OutputData,
  },

  attrs = {
    upstream_version = version,
    source_provenance = {
      category = 'GithubRepo,
      owner = "ngspice",
      repo = "ngspice",
    },
  },

  tests = {
    smoketest =
      {
        class = 'Standalone,
        test_deps = [base],
        cmds = [["/bin/bash", "-c", "ngspice -v 2>&1 | grep -q ngspice"]],
      } | Test,
  },
} | BuildSpec
