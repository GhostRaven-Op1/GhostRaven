#!/bin/bash
# Raven Hybrid Module
# Chains modules, collates evidence, hashes logs, generates text + HTML reports,
# optionally signs the hash manifest with GPG, and auto-exports the case into a tarball
# with embedded download links in the HTML report.

# Prereqs: sha256sum, awk; optional: gpg
# NOTE: Set CASE before running (e.g., export CASE="ACME_2025Q4")

if [ -z "$CASE" ]; then
  echo "❌ CASE variable not set. Please set CASE (e.g., export CASE=\"ACME_2025Q4\")."
  exit 1
fi

EVIDENCE_DIR="/mnt/GhostRaven/09📑Evidence/$CASE/hybrid"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_FILE="$EVIDENCE_DIR/mission_summary_${TIMESTAMP}.txt"
HASH_MANIFEST="$EVIDENCE_DIR/hash_manifest_${TIMESTAMP}.txt"

mkdir -p "$EVIDENCE_DIR"

clear
echo "=============================="
echo " 🔗 Raven Hybrid Engagement"
echo "=============================="
echo "This will run multiple modules in sequence."
echo "Evidence will be stored in: $EVIDENCE_DIR"
echo "=============================="
echo "Select chaining profile:"
echo "1) Core Chain (OSINT → Red Team → WebApp → Social)"
echo "2) Full Chain (OSINT → Red Team → WebApp → AS/400 → Social)"
echo "3) Extended Chain (OSINT → Red Team → WebApp → AS/400 → Social → Geo/Live Feeds)"
echo "4) Return to Main Menu"
echo "=============================="
read -p "Choose an option: " choice

# Initialize mission summary
{
  echo "=============================="
  echo " 🦅 Raven Hybrid Mission Log"
  echo " Case: $CASE"
  echo " Date: $(date)"
  echo "=============================="
  echo ""
} > "$REPORT_FILE"

run_module () {
    MODULE_NAME="$1"
    MODULE_PATH="$2"
    MODULE_STAMP="$(date +%H%M%S)"
    MODULE_LOG="$EVIDENCE_DIR/${MODULE_NAME// /_}_${MODULE_STAMP}.log"

    echo "▶ Running $MODULE_NAME..."
    echo "[$(date)] Starting $MODULE_NAME" >> "$REPORT_FILE"

    # Run module and capture output
    bash "$MODULE_PATH" 2>&1 | tee "$MODULE_LOG"

    # Hash the log for integrity
    HASH="$(sha256sum "$MODULE_LOG" | awk '{print $1}')"

    # Append details to mission summary
    {
      echo "[$(date)] Completed $MODULE_NAME"
      echo " Evidence: $MODULE_LOG"
      echo " SHA256: $HASH"
      echo ""
      echo "------------------------------"
      echo " 📑 Executive Summary: $MODULE_NAME"
      echo "------------------------------"
      head -n 20 "$MODULE_LOG"
      echo "... [truncated, see full log for details]"
      echo ""
    } >> "$REPORT_FILE"

    # Add to hash manifest
    echo "$HASH  $MODULE_LOG" >> "$HASH_MANIFEST"
}

case "$choice" in
    1)
        run_module "OSINT"           /mnt/GhostRaven/RAVEN/modules/osint_menu.sh
        run_module "Red Team"        /mnt/GhostRaven/RAVEN/modules/redteam_menu.sh
        run_module "WebApp"          /mnt/GhostRaven/RAVEN/modules/webapp_menu.sh
        run_module "Social"          /mnt/GhostRaven/RAVEN/modules/social_menu.sh
        ;;
    2)
        run_module "OSINT"           /mnt/GhostRaven/RAVEN/modules/osint_menu.sh
        run_module "Red Team"        /mnt/GhostRaven/RAVEN/modules/redteam_menu.sh
        run_module "WebApp"          /mnt/GhostRaven/RAVEN/modules/webapp_menu.sh
        run_module "AS/400"          /mnt/GhostRaven/RAVEN/modules/as400_menu.sh
        run_module "Social"          /mnt/GhostRaven/RAVEN/modules/social_menu.sh
        ;;
    3)
        run_module "OSINT"           /mnt/GhostRaven/RAVEN/modules/osint_menu.sh
        run_module "Red Team"        /mnt/GhostRaven/RAVEN/modules/redteam_menu.sh
        run_module "WebApp"          /mnt/GhostRaven/RAVEN/modules/webapp_menu.sh
        run_module "AS/400"          /mnt/GhostRaven/RAVEN/modules/as400_menu.sh
        run_module "Social"          /mnt/GhostRaven/RAVEN/modules/social_menu.sh
        run_module "Geo/Live Feeds"  /mnt/GhostRaven/RAVEN/modules/geo_menu.sh
        ;;
    4)
        echo "🔁 Returning to Main Menu..."
        exit 0
        ;;
    *)
        echo "❌ Invalid choice."
        sleep 1
        exit 1
        ;;
esac

# Wrap up mission summary
{
  echo "=============================="
  echo " ✅ Hybrid engagement complete."
  echo " Evidence stored in: $EVIDENCE_DIR"
  echo "=============================="
} >> "$REPORT_FILE"

# Finalize hash manifest header
{
  echo "=============================="
  echo " Raven Case Digest - Hash Manifest"
  echo " Case: $CASE"
  echo " Date: $(date)"
  echo "=============================="
} >> "$HASH_MANIFEST"

# Optional GPG signing
if command -v gpg &> /dev/null; then
    echo "🔐 GPG detected. Signing hash manifest..."
    gpg --output "$HASH_MANIFEST.sig" --clearsign "$HASH_MANIFEST"
    echo " GPG signature created: $HASH_MANIFEST.sig" >> "$REPORT_FILE"
else
    echo "⚠️ GPG not installed. Skipping signature." >> "$REPORT_FILE"
fi

# Prepare export first (so HTML can link to known filenames)
EXPORT_DIR="/mnt/GhostRaven/exports"
mkdir -p "$EXPORT_DIR"
EXPORT_FILE="$EXPORT_DIR/${CASE}_export_${TIMESTAMP}.tar.gz"

echo "📦 Packaging case export..."
# Tar the entire case folder (includes text, HTML, manifest, signature, logs)
tar -czf "$EXPORT_FILE" -C "$EVIDENCE_DIR/.." "$CASE"

# Hash the export
EXPORT_HASH="$(sha256sum "$EXPORT_FILE" | awk '{print $1}')"
echo "$EXPORT_HASH  $EXPORT_FILE" > "$EXPORT_FILE.sha256"

# Generate HTML report from mission summary, manifest, and signature, with download links
HTML_REPORT="$EVIDENCE_DIR/mission_summary_${TIMESTAMP}.html"
{
cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Raven Mission Report - $CASE</title>
<style>
:root { color-scheme: light dark; }
body { font-family: Arial, sans-serif; margin: 40px; background: #f4f4f4; color: #222; }
@media (prefers-color-scheme: dark) {
  body { background: #0f1115; color: #e6e6e6; }
  pre, .card { background: #171923; border-color: #2a2f3a; }
}
h1 { color: #2c3e50; margin-bottom: 0; }
h2 { color: #34495e; border-bottom: 2px solid #ccc; padding-bottom: 4px; }
.card { background: #fff; padding: 16px; border: 1px solid #ccc; border-radius: 8px; }
.section { margin-bottom: 30px; }
pre { padding: 12px; border: 1px solid #ccc; border-radius: 6px; overflow-x: auto; white-space: pre-wrap; }
.footer { font-size: 0.9em; color: #555; margin-top: 40px; }
.tag { display: inline-block; margin-right: 8px; font-size: 0.85em; color: #666; }
a.button { display: inline-block; margin: 6px 0; padding: 8px 12px; border: 1px solid #888; border-radius: 6px; text-decoration: none; }
</style>
</head>
<body>
<h1>🦅 Raven Mission Report</h1>
<div class="section card">
<h2>Case information</h2>
<p><span class="tag"><strong>Case:</strong> $CASE</span>
<span class="tag"><strong>Date:</strong> $(date)</span>
<span class="tag"><strong>Evidence:</strong> $EVIDENCE_DIR</span></p>
</div>
EOF

# Executive summaries from text report
awk '
/^ 📑 Executive Summary:/ {
    if (open) { print "</pre></div>" }
    open=1
    title=substr($0,5)
    print "<div class=\"section card\"><h2>" title "</h2><pre>"
    next
}
{ if (open) print }
END { if (open) print "</pre></div>" }
' "$REPORT_FILE"

# Hash manifest section
cat <<EOF
<div class="section card">
<h2>Hash manifest</h2>
<pre>
$(cat "$HASH_MANIFEST")
</pre>
</div>
EOF

# Signature section
cat <<EOF
<div class="section card">
<h2>Signature</h2>
<pre>
EOF

if [ -f "$HASH_MANIFEST.sig" ]; then
    cat "$HASH_MANIFEST.sig"
else
    echo "No signature present."
fi

# Downloads section (absolute file URLs for reliability)
EXPORT_URL="file://$EXPORT_FILE"
SHA_URL="file://$EXPORT_FILE.sha256"

cat <<EOF
</pre>
</div>

<div class="section card">
<h2>Downloads</h2>
<p>
<a class="button" href="$EXPORT_URL" download>📦 Download case archive</a><br>
<a class="button" href="$SHA_URL" download>🔑 Download SHA256 manifest</a>
</p>
<p><em>If downloads do not trigger from local file URLs, retrieve files directly from:</em><br>
<code>$EXPORT_FILE</code><br>
<code>$EXPORT_FILE.sha256</code></p>
</div>

<div class="footer">
<p>Generated by Raven Hybrid Module • $(date)</p>
</div>
</body>
</html>
EOF
} > "$HTML_REPORT"

echo " HTML report created: $HTML_REPORT" >> "$REPORT_FILE"

# Final console output
echo "=============================="
echo "✅ Hybrid engagement complete."
echo "Mission summary: $REPORT_FILE"
echo "HTML report:     $HTML_REPORT"
echo "Hash manifest:   $HASH_MANIFEST"
[ -f "$HASH_MANIFEST.sig" ] && echo "Signature:       $HASH_MANIFEST.sig"
echo "Export archive:  $EXPORT_FILE"
echo "Export SHA256:   $EXPORT_FILE.sha256"
echo "=============================="

read -p "Press Enter to return to Main Menu..."
