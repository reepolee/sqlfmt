#!/usr/bin/env bash
set -euo pipefail

cargo build --release

# binary at ./target/release/sqlfmt
# optionally copy to project root (sqlfmt, not sqlfmt.exe on mac/linux)
cp ./target/release/sqlfmt ./sqlfmt

# Remove build artifacts (binary was copied above)
rm -rf ./target

echo "Build complete. Binary copied to ./sqlfmt"
