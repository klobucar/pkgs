let { standaloneTest, Attrs, BuildSpec, Local, OutputBin, Source, Test, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let glibc = import "../glibc/build.ncl" in
let python = import "../python/build.ncl" in

let version = "1.3.10" in
{
  name = "bun",
  build_deps = [
    { file = "build.sh" } | Local,
    {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v%{version}/bun-linux-x64.zip",
      sha256 = "f57bc0187e39623de716ba3a389fda5486b2d7be7131a980ba54dc7b733d2e08",
    } | Source,
    base,
    python,
  ],
  runtime_deps = [
    glibc,
  ],

  cmd = "./build.sh",

  outputs = {
    bun = { glob = "usr/bin/bun" } | OutputBin,
    bunx = { glob = "usr/bin/bunx" } | OutputBin,
  },

  attrs =
    {
      upstream_version = version,
      env_state_wiring = {
        env_var = "BUN_INSTALL_CACHE_DIR",
        prefix = "bun-cache",
      },
      source_provenance = {
        category = 'GithubRepo,
        owner = "oven-sh",
        repo = "bun",
      },
    } | Attrs,

  tests = {
    smoketest = standaloneTest "/bin/bun --version",

    eval =
      {
        class = 'Standalone,
        test_deps = [base],
        cmds = [
          ["/bin/bash", "-c", "bun --eval 'console.log(1+1)' | grep -q '^2$'"],
        ],
      } | Test,
  },
} | BuildSpec
