#!/bin/bash
# Raven Geo/Live Feeds Module
# Evidence path: /mnt/GhostRaven/09📑Evidence/$CASE/geo/

EVIDENCE_DIR="/mnt/GhostRaven/09📑Evidence/$CASE/geo"
mkdir -p "$EVIDENCE_DIR"

while true; do
    clear
    echo "=============================="
    echo " 🌍 Raven Geo/Live Feeds Menu "
    echo "=============================="
    echo "1) Satellite Imagery (NASA/Sentinel)"
    echo "2) Live Maps (OSM/Google/Bing)"
    echo "3) Aircraft Tracking (ADS-B)"
    echo "4) Ship Tracking (AIS)"
    echo "5) Weather Overlays (NOAA/OWM)"
    echo "6) Return to Main Menu"
    echo "=============================="
    read -p "Choose an option: " choice

    case $choice in
        1)
            echo "🛰️ Satellite Imagery selected."
            echo "[Placeholder] Query NASA Worldview or Sentinel Hub API here."
            echo "Saving placeholder to $EVIDENCE_DIR/satellite.log"
            echo "$(date) - Satellite imagery query executed" >> "$EVIDENCE_DIR/satellite.log"
            read -p "Press Enter to continue..."
            ;;
        2)
            echo "🗺️ Live Maps selected."
            echo "[Placeholder] Call OpenStreetMap/Google Maps API here."
            echo "$(date) - Map query executed" >> "$EVIDENCE_DIR/maps.log"
            read -p "Press Enter to continue..."
            ;;
        3)
            echo "✈️ Aircraft Tracking selected."
            echo "[Placeholder] Query ADS-B Exchange API here."
            echo "$(date) - Aircraft tracking query executed" >> "$EVIDENCE_DIR/aircraft.log"
            read -p "Press Enter to continue..."
            ;;
        4)
            echo "🚢 Ship Tracking selected."
            echo "[Placeholder] Query AIS feed here."
            echo "$(date) - Ship tracking query executed" >> "$EVIDENCE_DIR/ships.log"
            read -p "Press Enter to continue..."
            ;;
        5)
            echo "🌦️ Weather Overlays selected."
            echo "[Placeholder] Query NOAA or OpenWeatherMap API here."
            echo "$(date) - Weather overlay query executed" >> "$EVIDENCE_DIR/weather.log"
            read -p "Press Enter to continue..."
            ;;
        6)
            echo "🔁 Returning to Main Menu..."
            break
            ;;
        *)
            echo "❌ Invalid choice."
            sleep 1
            ;;
    esac
done
