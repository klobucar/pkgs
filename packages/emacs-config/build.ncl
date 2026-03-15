let { Attrs, BuildSpec, Local, OutputData, Source, .. } = import "minimal.ncl" in
let base = import "../base/build.ncl" in
let emacs = import "../emacs/build.ncl" in
{
  name = "emacs-config",
  build_deps = [
    { file = "build.sh" } | Local,
    { file = "default.el" } | Local,

    # ── Completion framework ───────────────────────────────────────────
    {
      url = "https://github.com/minad/vertico/archive/refs/tags/2.8.tar.gz",
      sha256 = "b6b97cff92563ccd476b46d37a2d74239af5e6219ebbc30ac21e376fae30daf1",
      extract = true,
    } | Source,
    {
      url = "https://github.com/oantolin/orderless/archive/refs/tags/1.6.tar.gz",
      sha256 = "7d6d8ace8041bc179e6d25bd901909cb7d3c9f44dc9fa453bbd46094c7d86588",
      extract = true,
    } | Source,
    {
      url = "https://github.com/minad/marginalia/archive/refs/tags/2.10.tar.gz",
      sha256 = "0fbe3f182cebb7850527ee22a898c95e7145ecabb304886f8cc791f8ff21ff04",
      extract = true,
    } | Source,
    {
      url = "https://github.com/minad/consult/archive/refs/tags/3.4.tar.gz",
      sha256 = "22da07c49234516289307e1e6feab03785f9db75859088c197cbc219e7196f53",
      extract = true,
    } | Source,
    {
      url = "https://github.com/minad/corfu/archive/refs/tags/2.9.tar.gz",
      sha256 = "4144b729ea2712921a1ca35b6178fd06eb20d544508c0c105afcfdf22d242a38",
      extract = true,
    } | Source,

    # ── Which-key ──────────────────────────────────────────────────────
    {
      url = "https://github.com/justbur/emacs-which-key/archive/refs/tags/v3.6.0.tar.gz",
      sha256 = "b97a90c6db113d29b6404c0f29e240555d0b67c8cfc464fa04b05cdc38540e4f",
      extract = true,
    } | Source,

    # ── Magit and dependencies ─────────────────────────────────────────
    {
      url = "https://github.com/emacs-compat/compat/archive/refs/tags/30.1.0.1.tar.gz",
      sha256 = "ed424d15e462acd47fd58f5e86047d72393124063dc12841ee441aa0ac643f9a",
      extract = true,
    } | Source,
    {
      url = "https://github.com/magnars/dash.el/archive/refs/tags/2.20.0.tar.gz",
      sha256 = "77ca899620594a0e862863f03c137fcdf4551133697301cb712b200e80ee44c4",
      extract = true,
    } | Source,
    {
      url = "https://github.com/magit/transient/archive/refs/tags/v0.8.4.tar.gz",
      sha256 = "3e5a7290f020b008df6957b56f1f489b4bf789fb16c81be8fedc61a016fe5fd0",
      extract = true,
    } | Source,
    {
      url = "https://github.com/magit/with-editor/archive/refs/tags/v3.4.9.tar.gz",
      sha256 = "47ee6519666d976b16d4624cf349e68e96447ebb20ddf0d5cbb36b51d13b7702",
      extract = true,
    } | Source,
    {
      url = "https://github.com/magit/magit/archive/refs/tags/v4.1.3.tar.gz",
      sha256 = "1714bc53466611a5dffd66f86e7d0edc99537f1a74c73c3c92c3ac1795da8d46",
      extract = true,
    } | Source,

    # ── Extra modes ────────────────────────────────────────────────────
    {
      url = "https://github.com/jrblevin/markdown-mode/archive/refs/tags/v2.8.tar.gz",
      sha256 = "8252904252f771019c0b17e38be07cc8893e39da50e58dc5142dca50b0dd2dee",
      extract = true,
    } | Source,
    {
      url = "https://github.com/yoshiki/yaml-mode/archive/refs/tags/v0.0.13.tar.gz",
      sha256 = "c547b1ec62e6b39fd3e95e28b8d3918958d4f00391c471485532dbc6cc3dcab8",
      extract = true,
    } | Source,
    {
      url = "https://github.com/spotify/dockerfile-mode/archive/refs/tags/v1.7.tar.gz",
      sha256 = "13b03ff28ea8f7ad646dadd46113a9a191f0afca2c3d9182380441801d5af6a7",
      extract = true,
    } | Source,
    {
      url = "https://github.com/nickel-lang/nickel-mode/archive/e2dcd6cf66d9b5bcde3e3cd69efe053f73b081ab.tar.gz",
      sha256 = "209d5129ea006d0a335fbf82221878a6aa4796d18b048ce895d18473bc7d65a4",
      extract = true,
    } | Source,
    base,
    emacs,
  ],

  runtime_deps = [
    emacs,
  ],

  cmd = "./build.sh",

  outputs = {
    site-lisp = { glob = "usr/share/emacs/site-lisp/**" } | OutputData,
  },

  attrs =
    {} | Attrs,
} | BuildSpec
