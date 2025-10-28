#!/bin/bash
# Raven Report Generator — Collates evidence into TXT and PDF

echo "📝 Raven Report Generator"
report_dir="$case_dir/REPORTS"
mkdir -p "$report_dir"

timestamp=$(date +%Y%m%d_%H%M)
report_txt="$report_dir/${case_name}_report_${timestamp}.txt"
report_pdf="$report_dir/${case_name}_report_${timestamp}.pdf"

{
  echo "=============================="
  echo "   🦅 Raven Engagement Report"
  echo "=============================="
  echo "Case:        $case_name"
  echo "Target:      $target"
  echo "Operator:    $operator"
  echo "Engagement:  $engagement"
  echo "Date:        $(date)"
  echo ""
  echo "🔁 Automation: $automation"
  echo "🕸️ Tor:        $tor"
  echo "🕵️ Stealth:    $stealth"
  echo "=============================="
  echo ""

  # OSINT
  if [ -d "$case_dir/OSINT" ] || [ -d "$case_dir/AutomationProfile" ]; then
    echo "🛰️ OSINT Findings"
    [ -f "$case_dir/AutomationProfile/amass.txt" ] && cat "$case_dir/AutomationProfile/amass.txt"
    echo ""
  fi

  # Red Team
  if [ -d "$case_dir/AutomationProfile" ]; then
    echo "⚔️ Red Team Findings"
    [ -f "$case_dir/AutomationProfile/nmap.txt" ] && cat "$case_dir/AutomationProfile/nmap.txt"
    [ -f "$case_dir/AutomationProfile/nikto.txt" ] && cat "$case_dir/AutomationProfile/nikto.txt"
    echo ""
  fi

  # WebApp
  if [ -d "$case_dir/AutomationProfile/WebApp" ]; then
    echo "🌐 Web Application Findings"
    [ -f "$case_dir/AutomationProfile/WebApp/sqlmap/output.txt" ] && cat "$case_dir/AutomationProfile/WebApp/sqlmap/output.txt"
    [ -f "$case_dir/AutomationProfile/WebApp/xsstrike.txt" ] && cat "$case_dir/AutomationProfile/WebApp/xsstrike.txt"
    echo ""
  fi

  # AS/400
  if [ -d "$case_dir/AutomationProfile/AS400" ]; then
    echo "🟩 AS/400 Findings"
    [ -f "$case_dir/AutomationProfile/AS400/ports.txt" ] && cat "$case_dir/AutomationProfile/AS400/ports.txt"
    [ -f "$case_dir/AutomationProfile/AS400/deep_scan.txt" ] && cat "$case_dir/AutomationProfile/AS400/deep_scan.txt"
    echo ""
  fi

  # Social
  if [ -d "$case_dir/AutomationProfile/Social" ]; then
    echo "🎭 Social Engineering Notes"
    [ -f "$case_dir/AutomationProfile/Social/pretext.txt" ] && cat "$case_dir/AutomationProfile/Social/pretext.txt"
    [ -f "$case_dir/AutomationProfile/Social/persona.txt" ] && cat "$case_dir/AutomationProfile/Social/persona.txt"
    [ -f "$case_dir/AutomationProfile/Social/breach.txt" ] && cat "$case_dir/AutomationProfile/Social/breach.txt"
    echo ""
  fi

  echo "=============================="
  echo "End of Report"
  echo "=============================="
} > "$report_txt"

# Convert TXT to PDF (requires enscript + ps2pdf or pandoc)
if command -v enscript >/dev/null && command -v ps2pdf >/dev/null; then
  enscript -B -p - "$report_txt" | ps2pdf - "$report_pdf"
elif command -v pandoc >/dev/null; then
  pandoc "$report_txt" -o "$report_pdf"
else
  echo "⚠️ PDF conversion tools not found. Install enscript+ps2pdf or pandoc."
fi

sha256sum "$report_txt" >> "$case_dir/logs/evidence_hashes.txt"
[ -f "$report_pdf" ] && sha256sum "$report_pdf" >> "$case_dir/logs/evidence_hashes.txt"

echo "✅ Reports generated:"
echo "   TXT: $report_txt"
[ -f "$report_pdf" ] && echo "   PDF: $report_pdf"
