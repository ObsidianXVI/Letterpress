#!/usr/bin/env bash
#
# Build and deploy Letterpress to Firebase Hosting.
#
# The clean is not optional. `flutter build web` does not empty build/web first,
# and firebase.json deploys that directory wholesale, so files deleted from the
# source linger there and keep going to production — this repo was serving an
# orphaned 14 MB image and a stray `index copy.html` that way. See
# docs/media-and-hosting.md.

set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Analysing"
flutter analyze

echo "==> Testing"
# Chrome, not the VM: the design system imports package:web, which the VM
# cannot load at all.
flutter test --platform chrome

echo "==> Clean build"
flutter clean
flutter pub get
flutter build web --release

echo "==> Deploy size"
find build/web -type f ! -name '*.symbols' -exec ls -la {} \; |
  awk '{s+=$5} END {printf "    %.1f MB will be uploaded\n", s/1048576}'

echo "==> Deploying to Firebase Hosting"
npx -y firebase-tools@latest deploy --only hosting

echo "==> Done"
