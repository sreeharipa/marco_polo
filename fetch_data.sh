#!/usr/bin/env bash
# Download the pre-built map data (PMTiles + GeoJSON, ~95 MB) from the GitHub release into
# web/public/data, so the app runs without re-running the ~1 GB data pipeline.
# Usage: ./fetch_data.sh [release-tag]   (default: data-v6)
# The repo is private, so the download uses the GitHub CLI (`gh auth login` once). If the repo is
# made public, plain curl works too and is used when gh isn't installed.
set -euo pipefail
cd "$(dirname "$0")"
REPO="sreeharipa/marco_polo"
TAG="${1:-data-v6}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo "Downloading map data ($TAG, ~95 MB) from $REPO ..."
if command -v gh >/dev/null 2>&1; then
  gh release download "$TAG" -R "$REPO" --pattern "map-data.zip" --dir "$tmp"
else
  curl -fL --progress-bar -o "$tmp/map-data.zip" \
    "https://github.com/${REPO}/releases/download/${TAG}/map-data.zip"
fi
mkdir -p web/public/data
unzip -o -q "$tmp/map-data.zip" -d web/public/data
echo "Map data ($TAG) installed in web/public/data"
