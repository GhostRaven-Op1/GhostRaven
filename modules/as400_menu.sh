#!/bin/bash
# IBM i (AS/400) Assessment Module — Authorized testing only

echo "🟩 IBM i (AS/400) Assessment Module"
mkdir -p "$case_dir/AS400"
PS3="Choose an action: "
options=(
  "Detect IBM i services (ports & banners)"
  "TN5250 access (terminal check)"
  "Nmap deep service scan (IBM i host servers)"
  "Password audit (telnet/TN5250) — controlled"
  "DRDA/DB2 touch (non-invasive)"
  "Report pack (evidence collation)"
  "Switch Menu"
  "Back to Dashboard"
)

select opt in "${options[@]}"; do
  case $opt in
    "Detect IBM i services (ports & banners)")
      # Common IBM i indicators: TN5250 over telnet (23) / TLS (992), Host Servers (8470-8476), FTP(21), SSH(22)
      mkdir -p "$case_dir/AS400/detect"
      nmap -Pn -p 21,22,23,992,8470-8476 --version-all "$target" -oN "$case_dir/AS400/detect/ports.txt"
      # Grab minimal banners (safe)
      nmap -sV --script=banner -p 21,22,23,992,8470-8476 "$target" -oN "$case_dir/AS400/detect/banners.txt"
      sha256sum "$case_dir/AS400/detect/"* >> "$case_dir/logs/evidence_hashes.txt"
      ;;
    "TN5250 access (terminal check)")
      # Check TN5250 connectivity (non-auth), useful for confirming green-screen exposure
      echo "Opening TN5250 terminal (if client installed). Close window to return."
      tn5250 "$target" || echo "Install tn5250 client or confirm port 23/992 open."
      ;;
    "Nmap deep service scan (IBM i host servers)")
      mkdir -p "$case_dir/AS400/scan"
      nmap -sS -sV -p 21,22,23,992,8470-8476 -A "$target" -oN "$case_dir/AS400/scan/deep_scan.txt"
      sha256sum "$case_dir/AS400/scan/deep_scan.txt" >> "$case_dir/logs/evidence_hashes.txt"
      ;;
    "Password audit (telnet/TN5250) — controlled")
      echo "⚠️ Authorized testing only. Proceed with care."
      read -p "Username: " user
      read -sp "Password: " pass; echo
      # Example controlled attempt via hydra (limit attempts, log evidence)
      mkdir -p "$case_dir/AS400/auth"
      hydra -l "$user" -p "$pass" -t 2 -W 1 -f telnet://"${target}":23 -o "$case_dir/AS400/auth/telnet_auth.txt"
      sha256sum "$case_dir/AS400/auth/telnet_auth.txt" >> "$case_dir/logs/evidence_hashes.txt"
      ;;
    "DRDA/DB2 touch (non-invasive)")
      echo "Attempting non-invasive DRDA/DB2 ping on typical ports (446/448 if routed, host servers map)."
      mkdir -p "$case_dir/AS400/db2"
      nmap -Pn -p 446,448,8470 "$target" -sV -oN "$case_dir/AS400/db2/drda.txt"
      sha256sum "$case_dir/AS400/db2/drda.txt" >> "$case_dir/logs/evidence_hashes.txt"
      ;;
    "Report pack (evidence collation)")
      mkdir -p "$case_dir/AS400/report"
      {
        echo "IBM i (AS/400) Assessment Report — $(date)"
        echo "Target: $target"
        echo "Operator: $operator"
        echo ""
        echo "Services Detected:"
        [[ -f "$case_dir/AS400/detect/ports.txt" ]] && cat "$case_dir/AS400/detect/ports.txt"
        echo ""
        echo "Banners:"
        [[ -f "$case_dir/AS400/detect/banners.txt" ]] && cat "$case_dir/AS400/detect/banners.txt"
        echo ""
        echo "Deep Scan:"
        [[ -f "$case_dir/AS400/scan/deep_scan.txt" ]] && cat "$case_dir/AS400/scan/deep_scan.txt"
        echo ""
        echo "Auth Checks:"
        [[ -f "$case_dir/AS400/auth/telnet_auth.txt" ]] && cat "$case_dir/AS400/auth/telnet_auth.txt"
        echo ""
        echo "DRDA/DB2:"
        [[ -f "$case_dir/AS400/db2/drda.txt" ]] && cat "$case_dir/AS400/db2/drda.txt"
      } > "$case_dir/AS400/report/summary.txt"
      sha256sum "$case_dir/AS400/report/summary.txt" >> "$case_dir/logs/evidence_hashes.txt"
      echo "📑 Report generated: $case_dir/AS400/report/summary.txt"
      ;;
    "Switch Menu")
      echo "🔀 Switch to which menu?"
      select m in "OSINT" "Red Team" "WebApp" "Social Engineering" "Cancel"; do
        case $m in
          "OSINT") source "$base_dir/RAVEN/modules/osint_menu.sh"; break ;;
          "Red Team") source "$base_dir/RAVEN/modules/redteam_menu.sh"; break ;;
          "WebApp") source "$base_dir/RAVEN/modules/webapp_menu.sh"; break ;;
          "Social Engineering") source "$base_dir/RAVEN/modules/social_menu.sh"; break ;;
          "Cancel") break ;;
        esac
      done
      ;;
    "Back to Dashboard") break ;;
    *) echo "Invalid option" ;;
  esac
done
