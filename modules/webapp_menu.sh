#!/bin/bash
# Web Application Assessment Suite

echo "🌐 Web Application Assessment Suite"
mkdir -p "$case_dir/WebApp"
PS3="Choose a tool: "
options=(
  "Burp Suite CE     → Web proxy and scanner"
  "OWASP ZAP         → Passive/active web scanner"
  "SQLMap            → SQL injection detection and exploitation"
  "XSStrike          → Advanced XSS payload crafting"
  "WFuzz             → Web fuzzing for parameters and injection"
  "Dirb              → Directory brute-forcing"
  "Dirbuster         → GUI-based directory brute-forcing"
  "Commix            → Command injection exploitation"
  "Arjun             → Hidden parameter discovery"
  "BeEF              → Browser Exploitation Framework"
  "WET               → Automated CSRF/XSS/SQLi/open redirect/traversal"
  "Wappalyzer CLI    → Tech stack fingerprinting"
  "WhatWeb           → Web fingerprinting"
  "Switch Menu"
  "Back to Dashboard"
)
select opt in "${options[@]}"; do
  case $opt in
    "Burp Suite CE     → Web proxy and scanner") burpsuite & ;;
    "OWASP ZAP         → Passive/active web scanner") zaproxy & ;;
    "SQLMap            → SQL injection detection and exploitation") mkdir -p "$case_dir/WebApp/SQLMap"; read -p "Target URL: " url; sqlmap -u "$url" --batch --output-dir="$case_dir/WebApp/SQLMap"; sha256sum "$case_dir/WebApp/SQLMap/"* >> "$case_dir/logs/evidence_hashes.txt" ;;
    "XSStrike          → Advanced XSS payload crafting") mkdir -p "$case_dir/WebApp/XSStrike"; read -p "Target URL: " url; xsstrike -u "$url" -o "$case_dir/WebApp/XSStrike/output.txt"; sha256sum "$case_dir/WebApp/XSStrike/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "WFuzz             → Web fuzzing for parameters and injection") mkdir -p "$case_dir/WebApp/WFuzz"; read -p "Target URL (use FUZZ): " url; wfuzz -c -z file,/usr/share/wordlists/dirb/common.txt --hc 404 "$url" > "$case_dir/WebApp/WFuzz/output.txt"; sha256sum "$case_dir/WebApp/WFuzz/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Dirb              → Directory brute-forcing") mkdir -p "$case_dir/WebApp/Dirb"; read -p "Target URL: " url; dirb "$url" > "$case_dir/WebApp/Dirb/output.txt"; sha256sum "$case_dir/WebApp/Dirb/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Dirbuster         → GUI-based directory brute-forcing") dirbuster & ;;
    "Commix            → Command injection exploitation") mkdir -p "$case_dir/WebApp/Commix"; read -p "Target URL: " url; commix --url="$url" --output-dir="$case_dir/WebApp/Commix"; sha256sum "$case_dir/WebApp/Commix/"* >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Arjun             → Hidden parameter discovery") mkdir -p "$case_dir/WebApp/Arjun"; read -p "Target URL: " url; arjun -u "$url" -o "$case_dir/WebApp/Arjun/output.txt"; sha256sum "$case_dir/WebApp/Arjun/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "BeEF              → Browser Exploitation Framework") beef-xss & xdg-open http://127.0.0.1:3000/ui/panel ;;
    "WET               → Automated CSRF/XSS/SQLi/open redirect/traversal") cd /mnt/GhostRaven/tools/Web-Exploit-Toolkit; python3 main.py ;;
    "Wappalyzer CLI    → Tech stack fingerprinting") mkdir -p "$case_dir/WebApp/Wappalyzer"; read -p "Target URL: " url; wappalyzer "$url" > "$case_dir/WebApp/Wappalyzer/output.txt"; sha256sum "$case_dir/WebApp/Wappalyzer/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "WhatWeb           → Web fingerprinting") mkdir -p "$case_dir/WebApp/WhatWeb"; read -p "Target URL: " url; whatweb "$url" > "$case_dir/WebApp/WhatWeb/output.txt"; sha256sum "$case_dir/WebApp/WhatWeb/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Switch Menu")
      echo "🔀 Switch to which menu?"
      select m in "OSINT" "Red Team" "AS400" "Social Engineering" "Cancel"; do
        case $m in
          "OSINT") source "$base_dir/RAVEN/modules/osint_menu.sh"; break ;;
          "Red Team") source "$base_dir/RAVEN/modules/redteam_menu.sh"; break ;;
          "AS400") source "$base_dir/RAVEN/modules/as400_menu.sh"; break ;;
          "Social Engineering") source "$base_dir/RAVEN/modules/social_menu.sh"; break ;;
          "Cancel") break ;;
        esac
      done
      ;;
    "Back to Dashboard") break ;;
    *) echo "Invalid option" ;;
  esac
done
