#!/bin/sh
set -e

case $(uname -m) in
  x86_64)  PLATFORM="x86_64" ;;
  aarch64) PLATFORM="arm" ;;
  *)       echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

tar -xof "google-cloud-cli-${MINIMAL_ARG_VERSION}-linux-${PLATFORM}.tar.gz"

mkdir -p $OUTPUT_DIR/usr/{bin,lib}
mv google-cloud-sdk $OUTPUT_DIR/usr/lib/google-cloud-sdk

# Create wrapper scripts for the main CLI tools
for bin in gcloud gsutil bq; do
  cat > "${OUTPUT_DIR}/usr/bin/${bin}" << EOF
#!/bin/bash
exec /usr/lib/google-cloud-sdk/bin/${bin} "\$@"
EOF
  chmod +x "${OUTPUT_DIR}/usr/bin/${bin}"
done
