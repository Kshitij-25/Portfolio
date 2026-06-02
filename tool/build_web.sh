#!/usr/bin/env bash
# Build the portfolio for the web using the WasmGC renderer (smoothest option
# for this animation-heavy app). Output lands in build/web, ready to deploy.
set -euo pipefail

cd "$(dirname "$0")/.."

# Keep the bundled fallback in sync with the live, editable content file so the
# offline/mobile copy ships the same data as the deployed web/data/portfolio.json.
cp web/data/portfolio.json assets/portfolio.json

flutter build web --wasm --release "$@"

echo "✓ Built build/web (wasm). Serve with:  dart pub global activate dhttpd && dhttpd --path build/web"
