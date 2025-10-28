#!/bin/bash
# Social Engineering Module — Authorized use only

echo "🎭 Social Engineering Menu"
mkdir -p "$case_dir/Social"

PS3="Choose an action: "
options=(
  "Phish Pretext Builder (notes only)"
  "OSINT Persona Builder (notes only)"
  "Open Source Breach Queries (browser)"
  "Switch Menu"
  "Back to Dashboard"
)

select opt in "${options[@]}"; do
  case $opt in
    "Phish Pretext Builder (notes only)")
      read -p "Pretext summary: " p
      echo "$(date): $p" >> "$case_dir/Social/pretexts.txt"
      ;;
    "OSINT Persona Builder (notes only)")
      read -p "Persona summary: " s
      echo "$(date): $s" >> "$case_dir/Social/personas.txt"
      ;;
    "Open Source Breach Queries (browser)")
      xdg-open "https://haveibeenpwned.com/account/$target"
      ;;
    "Switch Menu")
      echo "🔀 Switch to which menu?"
      select m in "OSINT" "Red Team" "WebApp" "AS400" "Cancel"; do
        case $m in
          "OSINT") source "$base_dir/RAVEN/modules/osint_menu.sh"; break ;;
          "Red Team") source "$base_dir/RAVEN/modules/redteam_menu.sh"; break ;;
          "WebApp") source "$base_dir/RAVEN/modules/webapp_menu.sh"; break ;;
          "AS400") source "$base_dir/RAVEN/modules/as400_menu.sh"; break ;;
          "Cancel") break ;;
        esac
      done
      ;;
    "Back to Dashboard") break ;;
    *) echo "Invalid option" ;;
  esac
done
