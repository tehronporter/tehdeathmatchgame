#!/usr/bin/env bash
# Render the current main scene and save a screenshot for verification.
# Usage: ./verify.sh [output.png]
#
# This Intel Mac's MoltenVK (Vulkan) compute path is broken, so we verify with
# the OpenGL-compatibility renderer. iOS device export uses Godot's native
# Metal renderer and is unaffected. Run from the repo root or the godot/ dir.
set -euo pipefail

OUT="${1:-/tmp/deathmatch_verify.png}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

rm -f "$OUT"
timeout 60 godot --path "$DIR" \
  --rendering-method gl_compatibility \
  --rendering-driver opengl3 \
  -- --screenshot "$OUT"

echo "Saved screenshot: $OUT"
