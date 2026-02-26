let { harness, .. } = import "minimal.ncl" in
harness {
  name = "shell",
  build_packages = ["base", "curl"],
  build_cmd = "true",
}
