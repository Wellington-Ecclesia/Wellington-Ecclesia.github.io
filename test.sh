#!/bin/sh
set -e

IMAGE="jekyll-pages-local"

if ! podman image exists "$IMAGE" 2>/dev/null; then
  echo "Building $IMAGE..."
  podman build -t "$IMAGE" - <<'EOF'
FROM docker.io/jekyll/jekyll:pages
RUN gem install webrick jekyll-livereload --no-document
EOF
fi

podman run --rm -v "$PWD:/srv/jekyll:Z" -p 4000:4000 -p 35729:35729 \
  -e JEKYLL_ROOTLESS=true \
  -e PAGES_REPO_NWO=Wellington-Ecclesia/Wellington-Ecclesia.github.io \
  "$IMAGE" \
  jekyll serve --watch --livereload --destination /tmp/_site --host 0.0.0.0
