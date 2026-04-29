let { Attrs, BuildSpec, Local, Needs, OutputBin, Source, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let go = import "../go/build.ncl" in

let version = "0.4.42" in
{
  name = "flyctl",
  build_deps = [
    { file = "build.sh" } | Local,
    {
      url = "https://github.com/superfly/flyctl/archive/refs/tags/v%{version}.tar.gz",
      sha256 = "c9ba3cf945fd6bdce6def153b17616a85bb974f3299e573f77ae0403f3bb6d33",
      extract = true,
      strip_prefix = "flyctl-%{version}",
    } | Source,
    base,
    go,
  ],

  needs =
    {
      dns = {},
      internet = {},
    } | Needs,

  cmd = "./build.sh",
  build_args = {
    include version,
  },

  outputs = {
    flyctl = { glob = "usr/bin/flyctl" } | OutputBin,
    fly = { glob = "usr/bin/fly" } | OutputBin,
  },

  attrs =
    {
      upstream_version = version,
      source_provenance = {
        category = 'GithubRepo,
        owner = "superfly",
        repo = "flyctl",
      },
      build_cost_multiple = 2,
    } | Attrs,
} | BuildSpec
