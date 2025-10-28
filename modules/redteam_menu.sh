#!/bin/bash
# Red Team Arsenal Menu

echo "🔥 Red Team Arsenal Menu"
modes=("Passive" "Aggressive" "Stealth" "SuperStealth")
select m in "${modes[@]}"; do
  case $m in
    "Passive") mode="PASSIVE"; break ;;
    "Aggressive") mode="AGGRESSIVE"; break ;;
    "Stealth") mode="STEALTH"; break ;;
    "SuperStealth") mode="SUPERSTEALTH"; break ;;
    *) echo "Invalid mode";;
  esac
done
echo "⚔️ Mode set: $mode"

PS3="Choose a tool: "
options=(
  "Nmap        → Network mapper [All]"
  "Nikto       → Web server scanner [Passive,Aggressive]"
  "Exploit Pack→ Exploitation framework [Aggressive]"
  "Sliver C2   → Command & control framework [Aggressive]"
  "BloodHound  → AD attack paths [Stealth,Aggressive]"
  "Metasploit  → Exploitation framework [Aggressive]"
  "msfvenom    → Payload generator [Aggressive]"
  "Enum4linux  → SMB/Windows enumeration [Stealth]"
  "Responder   → Hash capture & poisoning [Aggressive]"
  "Wireshark   → Packet analysis [All]"
  "Bettercap   → MITM framework [Stealth,Aggressive]"
  "Ettercap    → Classic MITM suite [Aggressive]"
  "SSLStrip    → HTTPS downgrade [Aggressive]"
  "WiFi Pineapple→ Rogue AP [Aggressive]"
  "Wifite      → Automated wireless attacks [Aggressive]"
  "Aircrack-ng Suite→ Wireless toolkit [Aggressive]"
  "Switch Menu"
  "Back to Dashboard"
)
select opt in "${options[@]}"; do
  case $opt in
    "Nmap        → Network mapper [All]")
      mkdir -p "$case_dir/Nmap"
      if [[ "$mode" == "PASSIVE" ]]; then nmap -sL "$target" -oN "$case_dir/Nmap/passive.txt";
      elif [[ "$mode" == "AGGRESSIVE" ]]; then nmap -A "$target" -oN "$case_dir/Nmap/aggressive.txt";
      elif [[ "$mode" == "STEALTH" ]]; then nmap -sS -T2 "$target" -oN "$case_dir/Nmap/stealth.txt";
      else nmap -sS -T1 --data-length 16 --randomize-hosts "$target" -oN "$case_dir/Nmap/superstealth.txt"; fi
      sha256sum "$case_dir/Nmap/"* >> "$case_dir/logs/evidence_hashes.txt"
      ;;
    "Nikto       → Web server scanner [Passive,Aggressive]") mkdir -p "$case_dir/Nikto"; nikto -h "$target" -output "$case_dir/Nikto/scan.txt"; sha256sum "$case_dir/Nikto/scan.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Exploit Pack→ Exploitation framework [Aggressive]") exploitpack & ;;
    "Sliver C2   → Command & control framework [Aggressive]") sliver-server & ;;
    "BloodHound  → AD attack paths [Stealth,Aggressive]") mkdir -p "$case_dir/BloodHound"; bloodhound-python -d "$target" -c All -ip "$target" -o "$case_dir/BloodHound/" ;;
    "Metasploit  → Exploitation framework [Aggressive]") msfconsole ;;
    "msfvenom    → Payload generator [Aggressive]") mkdir -p "$case_dir/msfvenom"; read -p "Payload type: " payload; read -p "LHOST: " lhost; read -p "LPORT: " lport; read -p "Format: " format; read -p "Filename: " filename; msfvenom -p "$payload" LHOST="$lhost" LPORT="$lport" -f "$format" -o "$case_dir/msfvenom/$filename"; sha256sum "$case_dir/msfvenom/$filename" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Enum4linux  → SMB/Windows enumeration [Stealth]") mkdir -p "$case_dir/Enum4linux"; enum4linux -a "$target" > "$case_dir/Enum4linux/output.txt"; sha256sum "$case_dir/Enum4linux/output.txt" >> "$case_dir/logs/evidence_hashes.txt" ;;
    "Responder   → Hash capture & poisoning [Aggressive]") sudo responder -I eth0 ;;
    "Wireshark   → Packet analysis [All]") wireshark & ;;
    "Bettercap   → MITM framework [Stealth,Aggressive]") sudo bettercap -iface eth0 ;;
    "Ettercap    → Classic MITM suite [Aggressive]") sudo ettercap -G ;;
    "SSLStrip    → HTTPS downgrade [Aggressive]") sslstrip -l 8080 ;;
    "WiFi Pineapple→ Rogue AP [Aggressive]") xdg-open "http://172.16.42.1:1471" ;;
    "Wifite      → Automated wireless attacks [Aggressive]") sudo wifite ;;
    "Aircrack-ng Suite→ Wireless toolkit [Aggressive]") echo "Aircrack-ng suite available (airmon-ng, airodump-ng, aireplay-ng, aircrack-ng...)" ;;
    "Switch Menu")
      echo "🔀 Switch to which menu?"
      select m in "OSINT" "WebApp" "AS400" "Social Engineering" "Cancel"; do
        case $m in
          "OSINT") source "$base_dir/RAVEN/modules/osint_menu.sh"; break ;;
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
