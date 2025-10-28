#!/bin/bash
# Raven Case Export Script
# Bundles mission summary, hash manifest, signature, and evidence into a tarball

if [ -z "$1" ]; then
    echo "Usage: $0 <CASE_NAME>"
    exit 1
fi

CASE=$1
CASE_DIR="/mnt/GhostRaven/09📑Evidence/$CASE"

if [ ! -d "$CASE_DIR" ]; then
    echo "❌ Case directory not found: $CASE_DIR"
    exit 1
fi

EXPORT_DIR="/mnt/GhostRaven/exports"
mkdir -p "$EXPORT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
EXPORT_FILE="$EXPORT_DIR/${CASE}_export_$TIMESTAMP.tar.gz"

echo "=============================="
echo " 🦅 Raven Case Export"
echo " Case: $CASE"
echo " Source: $CASE_DIR"
echo " Export: $EXPORT_FILE"
echo "=============================="

# Create tarball with all evidence, reports, and signatures
tar -czvf "$EXPORT_FILE" -C "$CASE_DIR" .

# Generate SHA256 hash of the export
EXPORT_HASH=$(sha256sum "$EXPORT_FILE" | awk '{print $1}')
echo "$EXPORT_HASH  $EXPORT_FILE" > "$EXPORT_FILE.sha256"

echo "✅ Export complete."
echo " Archive: $EXPORT_FILE"
echo " SHA256:  $EXPORT_HASH"
echo " Manifest: $EXPORT_FILE.sha256"
echo "=============================="
