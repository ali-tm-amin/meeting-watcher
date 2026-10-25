#!/bin/bash
# Maintainer only: builds the ready-made detector (bin/mic-users) so users
# don't need Apple's developer tools. Run on your Mac, then commit bin/mic-users.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p bin

swiftc -O -target arm64-apple-macos14.2  mic-users.swift -o bin/mic-users-arm64
swiftc -O -target x86_64-apple-macos14.2 mic-users.swift -o bin/mic-users-x86_64
lipo -create bin/mic-users-arm64 bin/mic-users-x86_64 -output bin/mic-users
rm bin/mic-users-arm64 bin/mic-users-x86_64
codesign --force --sign - bin/mic-users

file bin/mic-users
echo "Built bin/mic-users (Apple Silicon + Intel). Quick test — apps using the mic right now:"
./bin/mic-users || true
