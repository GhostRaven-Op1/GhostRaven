#!/bin/bash
# Raven Automation Profile System — Ghost Raven Ops Drive

echo "🔁 Raven Automation Profile System"
echo "Engagement Type: $engagement | Automation: $automation"

if [[ "$automation" == "OFF" ]]; then
  echo "⚠️ Automation is disabled. Enable it in RAVEN_CONFIG/toggles.cfg"
  exit 1
fi

mkdir -p "$case_dir/AutomationProfile"
log="$case_dir/AutomationProfile/automation_log.txt"

echo "🔗 Starting automation chain..." | tee -a "$log"

# OSINT Chain
if [[ "$engagement" == "OSINT" || "$engagement" == "Hybrid" ]]; then
  echo "🛰️ Running OSINT chain..." | tee -a "$log"
  sublist3r -d "$target" -o "$case_dir/AutomationProfile/subdomains.txt"
  theHarvester -d "$target" -b all -f "$case_dir/AutomationProfile/harvest.html"
  amass enum -d "$target" -o "$case_dir/AutomationProfile/amass.txt"
  sha256sum "$case_dir/AutomationProfile/"* >> "$case_dir/logs/evidence_hashes.txt"
fi

# Red Team Chain
if [[ "$engagement" == "Red Team" || "$engagement" == "Hybrid" ]]; then
  echo "⚔️ Running Red Team chain..." | tee -a "$log"
  nmap -A "$target" -oN "$case_dir/AutomationProfile/nmap.txt"
  nikto -h "$target" -output "$case_dir/AutomationProfile/nikto.txt"
  sha256sum "$case_dir/AutomationProfile/"* >> "$case_dir/logs/evidence_hashes.txt"
fi

# WebApp Chain
if [[ "$engagement" == "WebApp" || "$engagement" == "Hybrid" ]]; then
  echo "🌐 Running WebApp chain..." | tee -a "$log"
  mkdir -p "$case_dir/AutomationProfile/WebApp"
  arjun -u "$target" -o "$case_dir/AutomationProfile/WebApp/arjun.txt"
  wfuzz -c -z file,/usr/share/wordlists/dirb/common.txt --hc 404 "$target/FUZZ" > "$case_dir/AutomationProfile/WebApp/wfuzz.txt"
  sqlmap -u "$target" --batch --output-dir="$case_dir/AutomationProfile/WebApp/sqlmap"
  xsstrike -u "$target" -o "$case_dir/AutomationProfile/WebApp/xsstrike.txt"
  cd /mnt/GhostRaven/tools/Web-Exploit-Toolkit && python3 main.py --url "$target" --output "$case_dir/AutomationProfile/WebApp/wet.txt"
  sha256sum "$case_dir/AutomationProfile/WebApp/"* >> "$case_dir/logs/evidence_hashes.txt"
fi

# AS/400 Chain
if [[ "$engagement" == "AS400" || "$engagement" == "Hybrid" ]]; then
  echo "🟩 Running AS/400 chain..." | tee -a "$log"
  mkdir -p "$case_dir/AutomationProfile/AS400"
  nmap -Pn -p 21,22,23,992,8470-8476 --version-all "$target" -oN "$case_dir/AutomationProfile/AS400/ports.txt"
  nmap -sV --script=banner -p 21,22,23,992,8470-8476 "$target" -oN "$case_dir/AutomationProfile/AS400/banners.txt"
  nmap -sS -sV -p 21,22,23,992,8470-8476 -A "$target" -oN "$case_dir/AutomationProfile/AS400/deep_scan.txt"
  sha256sum "$case_dir/AutomationProfile/AS400/"* >> "$case_dir/logs/evidence_hashes.txt"
fi

# Social Engineering Chain
if [[ "$engagement" == "Social" || "$engagement" == "Hybrid" ]]; then
  echo "🎭 Running Social Engineering chain..." | tee -a "$log"
  mkdir -p "$case_dir/AutomationProfile/Social"
  echo "Pretext placeholder for $target" > "$case_dir/AutomationProfile/Social/pretext.txt"
  echo "Persona placeholder for $target" > "$case_dir/AutomationProfile/Social/persona.txt"
  echo "Breach query prepared for $target" > "$case_dir/AutomationProfile/Social/breach.txt"
  sha256sum "$case_dir/AutomationProfile/Social/"* >> "$case_dir/logs/evidence_hashes.txt"
fi

echo "✅ Automation chain complete." | tee -a "$log"

# Auto-generate report if Hybrid
if [[ "$engagement" == "Hybrid" ]]; then
  echo "📝 Generating final report..." | tee -a "$log"
  source "$base_dir/RAVEN/modules/report_generator.sh"
fi
