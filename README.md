# GhostRaven
OSINT/Red Team Suite
# 🦅 GhostRaven: Op1 BountyOps Suite

**Operator:** GhostRaven‑Op1  
**Domain:** OSINT • Red Team • Bug Bounty Hunting  
**Mission:** Reconnaissance • Exploit Validation • Forensic‑Grade Reporting

---

## ⚡ Overview
GhostRaven: BountyOps is a **modular, encrypted, and portable suite** engineered for operators who live at the intersection of **OSINT, Red Team tradecraft, and bug bounty hunting**.  
It’s designed to move seamlessly from reconnaissance to exploitation to reporting — with **automation profiles** that chain tools together and **forensic integrity** baked into every step.

This is not a script collection. It’s a **field‑ready operations platform**.

---

## 🧩 Core Capabilities

### 🔍 OSINT Recon
- Subfinder, Amass, Assetfinder, Recon‑ng, crt.sh, SpiderFoot, FOCA  
- Shodan integration with hardened error handling  
- PhoneInfoga + NumVerify for identity and phone intelligence  
- Metadata extraction across files, images, and facial recognition  

### ⚔️ Red Team Arsenal
- Nuclei, Nikto, Wappalyzer, WhatWeb  
- Metasploit, XSStrike, SQLMap, Commix  
- Legacy awareness: AS/400 (IBM i), TN5250 probes, spool file decoding  

### 🎯 Bug Bounty Hunting
- Automation profiles to chain recon → scan → exploit validation  
- Vendor Trust Audit: CVE checks, breach history, supply chain risk scoring  
- Social Engineering Intel: HaveIBeenPwned, DeHashed, LeakCheck, IntelligenceX, DataBreach.com  

---

## 🔐 Forensic Integrity
- **Hash manifests** for every run  
- **GPG signatures** for verification  
- **Automatic exports** with timestamped, collated results  
- **Dual deliverables**: raw data + styled HTML reports  

---

## 🚀 Quick Start
```bash
git clone https://github.com/GhostRaven-Op1/GhostRaven.git
cd GhostRaven
chmod +x raven.sh
./raven.sh
