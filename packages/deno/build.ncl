let { standaloneTest, subsetOf, Attrs, BuildSpec, Local, OutputBin, Source, Test, .. } = import "minimal.ncl" in
let { target, .. } = import "config.ncl" in
let base = import "../base/build.ncl" in
let glibc = import "../glibc/build.ncl" in
let gcc = import "../gcc/build.ncl" in
let python = import "../python/build.ncl" in

let version = "2.7.2" in
{
  name = "deno",
  build_deps = [
    { file = "build.sh" } | Local,
    match {
      { arch = 'Amd64, .. } =>
        {
          url = "https://github.com/denoland/deno/releases/download/v%{version}/deno-x86_64-unknown-linux-gnu.zip",
          sha256 = "bc3af4d1bedd7893664b925c0f39fb08f7b12242e57ed4acdc0cf64540b4449c",
        } | Source,
      { arch = 'Arm64, .. } =>
        {
          url = "https://github.com/denoland/deno/releases/download/v%{version}/deno-aarch64-unknown-linux-gnu.zip",
          sha256 = "c36c0b284d084dfe7045a106e60bd98d919183fd69d7902a42f3c7a244bf4386",
        } | Source,
    } target,
    base,
    python,
  ],
  runtime_deps = [
    glibc,
    subsetOf gcc ["libgcc"],
  ],

  cmd = "./build.sh",

  outputs = {
    deno = { glob = "usr/bin/deno" } | OutputBin,
  },

  attrs =
    {
      upstream_version = version,
      env_state_wiring = {
        env_var = "DENO_DIR",
        prefix = "deno-cache",
      },
      source_provenance = {
        category = 'GithubRepo,
        owner = "denoland",
        repo = "deno",
      },
    } | Attrs,

  tests = {
    smoketest = standaloneTest "/usr/bin/deno --version",

    eval =
      {
        class = 'Standalone,
        test_deps = [base],
        cmds = [
          ["/bin/bash", "-c", "deno eval 'console.log(1+1)' | grep -q '^2$'"],
        ],
      } | Test,
  },
} | BuildSpec
