#!/bin/bash
# OSINT Collection Menu

echo "🛰️ OSINT Collection Menu"
PS3="Choose a tool: "
options=(
  "Amass        → Map subdomains & network ranges"
  "SpiderFoot   → Automated OSINT scanner with web GUI"
  "Recon-ng     → Modular reconnaissance framework"
  "Sublist3r    → Fast subdomain enumerator"
  "crt.sh       → Certificate transparency search"
  "theHarvester → Emails, hosts, and subdomains"
  "FOCA         → Extract metadata from documents"
  "ExifTool     → Metadata from images/audio/video"
  "PhoneInfoga  → Phone number OSINT"
  "Shodan       → Internet device search engine"
  "IntelligenceX→ Leaked data & darknet search"
  "LeakCheck    → Breach data lookup"
  "DeHashed     → Breach data lookup"
  "HaveIBeenPwned→ Breach data lookup"
  "Wayback      → Historical website snapshots"
  "Maltego CE   → Graphical link analysis"
  "NumVerify    → Phone validation & carrier/region info"
  "Switch Menu"
  "Back to Dashboard"
)
select opt in "${options[@]}"; do
  case $opt in
    "Amass        → Map subdomains & network ranges") amass enum -d "$target" -o "$case_dir/OSINT/amass.txt" ;;
    "SpiderFoot   → Automated OSINT scanner with web GUI") spiderfoot -l 0.0.0.0:5001 & ;;
    "Recon-ng     → Modular reconnaissance framework") recon-ng ;;
    "Sublist3r    → Fast subdomain enumerator") sublist3r -d "$target" -o "$case_dir/OSINT/subs.txt" ;;
    "crt.sh       → Certificate transparency search") xdg-open "https://crt.sh/?q=$target" ;;
    "theHarvester → Emails, hosts, and subdomains") theHarvester -d "$target" -b all -f "$case_dir/OSINT/harvest.html" ;;
    "FOCA         → Extract metadata from documents") echo "FOCA (Windows) — run via VM if needed." ;;
    "ExifTool     → Metadata from images/audio/video") read -p "File path: " f; exiftool "$f" > "$case_dir/OSINT/exiftool.txt" ;;
    "PhoneInfoga  → Phone number OSINT") read -p "Phone number: " p; phoneinfoga scan -n "$p" > "$case_dir/OSINT/phone.txt" ;;
    "Shodan       → Internet device search engine") xdg-open "https://www.shodan.io/search?query=$target" ;;
    "IntelligenceX→ Leaked data & darknet search") xdg-open "https://intelx.io/?s=$target" ;;
    "LeakCheck    → Breach data lookup") echo "Query prepared: $target" > "$case_dir/OSINT/leakcheck.txt" ;;
    "DeHashed     → Breach data lookup") echo "Query prepared: $target" > "$case_dir/OSINT/dehashed.txt" ;;
    "HaveIBeenPwned→ Breach data lookup") xdg-open "https://haveibeenpwned.com/account/$target" ;;
    "Wayback      → Historical website snapshots") xdg-open "https://web.archive.org/web/*/$target/*" ;;
    "Maltego CE   → Graphical link analysis") maltego & ;;
    "NumVerify    → Phone validation & carrier/region info") xdg-open "https://numverify.com/" ;;
    "Switch Menu")
      echo "🔀 Switch to which menu?"
      select m in "Red Team" "WebApp" "AS400" "Social Engineering" "Cancel"; do
        case $m in
          "Red Team") source "$base_dir/RAVEN/modules/redteam_menu.sh"; break ;;
          "WebApp") source "$base_dir/RAVEN/modules/webapp_menu.sh"; break ;;
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
