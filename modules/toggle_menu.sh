#!/bin/bash
# Raven Toggle Control Menu — Ghost Raven Ops Drive

config_file="/mnt/GhostRaven/RAVEN_CONFIG/toggles.cfg"

# Load current values
automation=$(grep -oP '(?<=AUTOMATION=).*' "$config_file")
tor=$(grep -oP '(?<=TOR=).*' "$config_file")
stealth=$(grep -oP '(?<=STEALTH=).*' "$config_file")

echo "🧠 Raven Toggle Control Menu"
echo "Current Settings:"
echo "  🔁 Automation: $automation"
echo "  🕸️ Tor Routing: $tor"
echo "  🕵️ Stealth Mode: $stealth"
echo ""

PS3="Select a toggle to change: "
options=("Automation" "Tor" "Stealth" "Exit")
select opt in "${options[@]}"; do
  case $opt in
    "Automation")
      echo "Toggle Automation:"
      select a in "ON" "OFF"; do
        sed -i "s/^AUTOMATION=.*/AUTOMATION=$a/" "$config_file"
        echo "✅ Automation set to $a"
        break
      done
      ;;
    "Tor")
      echo "Toggle Tor Routing:"
      select t in "ON" "OFF"; do
        sed -i "s/^TOR=.*/TOR=$t/" "$config_file"
        echo "✅ Tor set to $t"
        break
      done
      ;;
    "Stealth")
      echo "Set Stealth Mode:"
      select s in "PASSIVE" "STEALTH" "AGGRESSIVE" "SUPERSTEALTH"; do
        sed -i "s/^STEALTH=.*/STEALTH=$s/" "$config_file"
        echo "✅ Stealth mode set to $s"
        break
      done
      ;;
    "Exit")
      break
      ;;
    *)
      echo "Invalid selection"
      ;;
  esac
done
