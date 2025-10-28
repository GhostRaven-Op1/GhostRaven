#!/bin/bash
# Raven Main Launcher
# Case evidence path: /mnt/GhostRaven/09📑Evidence/$CASE

clear
echo "=============================="
echo "   🦅 Raven Main Launcher"
echo "=============================="
read -p "Enter Case Name: " CASE
export CASE

EVIDENCE_DIR="/mnt/GhostRaven/09📑Evidence/$CASE"
mkdir -p "$EVIDENCE_DIR"

while true; do
    clear
    echo "=============================="
    echo "   🦅 Raven Module Overview"
    echo "=============================="
    echo "1) 🛰️  OSINT            → Subdomains, metadata, breach data"
    echo "2) ⚔️  Red Team         → Exploitation, C2, network attacks"
    echo "3) 🌐  WebApp           → SQLi, XSS, fuzzing, fingerprinting"
    echo "4) 🟩  AS/400 (IBM i)   → TN5250, Host Servers, DB2/DRDA"
    echo "5) 🎭  Social           → Pretexts, personas, breach queries"
    echo "6) 🔗  Hybrid           → Chains all modules in sequence"
    echo "7) 🌍  Geo/Live Feeds   → Maps, satellite imagery, AIS/ADS-B, weather"
    echo "8) Exit"
    echo "=============================="
    read -p "Choose an option: " choice

    case $choice in
        1)
            bash /mnt/GhostRaven/RAVEN/modules/osint_menu.sh
            ;;
        2)
            bash /mnt/GhostRaven/RAVEN/modules/redteam_menu.sh
            ;;
        3)
            bash /mnt/GhostRaven/RAVEN/modules/webapp_menu.sh
            ;;
        4)
            bash /mnt/GhostRaven/RAVEN/modules/as400_menu.sh
            ;;
        5)
            bash /mnt/GhostRaven/RAVEN/modules/social_menu.sh
            ;;
        6)
            bash /mnt/GhostRaven/RAVEN/modules/hybrid_menu.sh
            ;;
        7)
            bash /mnt/GhostRaven/RAVEN/modules/geo_menu.sh
            ;;
        8)
            echo "👋 Exiting Raven. Stay sharp."
            exit 0
            ;;
        *)
            echo "❌ Invalid choice."
            sleep 1
            ;;
    esac
done
