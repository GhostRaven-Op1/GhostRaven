#!/bin/bash
# Raven Case Verification Script
# Validates SHA256 hashes and optional GPG signature for a given case

if [ -z "$1" ]; then
    echo "Usage: $0 <CASE_NAME>"
    exit 1
fi

CASE=$1
CASE_DIR="/mnt/GhostRaven/09📑Evidence/$CASE/hybrid"

if [ ! -d "$CASE_DIR" ]; then
    echo "❌ Case directory not found: $CASE_DIR"
    exit 1
fi

echo "=============================="
echo " 🦅 Raven Case Verification"
echo " Case: $CASE"
echo " Directory: $CASE_DIR"
echo "=============================="

# Find the latest hash manifest
HASH_MANIFEST=$(ls -t "$CASE_DIR"/hash_manifest_*.txt 2>/dev/null | head -n 1)

if [ -z "$HASH_MANIFEST" ]; then
    echo "❌ No hash manifest found in $CASE_DIR"
    exit 1
fi

echo "Using manifest: $HASH_MANIFEST"
echo "=============================="

# Verify SHA256 hashes
sha256sum -c "$HASH_MANIFEST"

# Check for GPG signature
if [ -f "$HASH_MANIFEST.sig" ]; then
    echo "=============================="
    echo "🔐 Verifying GPG signature..."
    gpg --verify "$HASH_MANIFEST.sig" "$HASH_MANIFEST"
else
    echo "⚠️ No GPG signature found for this manifest."
fi

echo "=============================="
echo " ✅ Verification complete."
echo "=============================="
