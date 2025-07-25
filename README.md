# VIRA – Voice. Impact. Relief. Access.

A gender-sensitive, offline-first emergency communication system using LoRa and Flutter for disaster resilience.

---

## Project Overview

**VIRA (Voice. Impact. Relief. Access.)** is a low-cost, wearable emergency alert system designed for women and vulnerable communities in disaster-affected zones. It bridges the communication gap during crises where traditional mobile networks fail.

With just one press, users can silently send distress alerts over **LoRa** or **Bluetooth Mesh** to a base station. The alerts are visualized on a centralized **Flutter dashboard** used by NGOs and responders, enabling life-saving interventions.

---

## Problem Statement

In emergency zones, women often face:

- Unsafe conditions  
- Lack of medical aid and sanitation  
- No private channel to seek help

VIRA ensures silent, private, and **offline** distress communication for faster, safer relief.

---

## Live Links

- **App:** [https://vira-93d85.web.app](https://vira-93d85.web.app)  
- **Website:** [https://devikasajith.github.io/Vira_website/](https://devikasajith.github.io/Vira_website/)

---

## Key Features

- One-touch emergency alert buttons for **medical**, **essentials**, and **safety** needs  
- Offline communication through **LoRa** or **Bluetooth Mesh**  
- **LED and vibration feedback** for real-time delivery acknowledgment  
- **ACK-based duplex system** to ensure delivery confirmation  
- Privacy-preserving system using anonymized Device IDs and optional NFC tags  
- **Firebase integration** for alert logging and analysis  
- **Flutter dashboard** for real-time tracking and resolution  
- Cost-effective design (~₹1200/unit), scalable for humanitarian use  

---

## Tech Stack

### Hardware
- ESP32 Microcontroller + LoRa (RFM95)
- Waterproof wearable case (IP65+)
- Rechargeable Li-ion battery (deep sleep optimized)
- Three physical buttons (for alert types)
- LED and vibration motor for delivery feedback

### Software
- Embedded C++ firmware for ESP32 and LoRa modules
- Flutter application for web/mobile dashboard
- Firebase for backend and cloud data logging
- Low-bandwidth dashboard design for emergency settings

---

## System Architecture

VIRA is designed as an **offline-first**, duplex emergency communication system using LoRa.

### Communication Flow

1. **User Interaction**  
   - The user presses a dedicated button for:
     - Medical Help  
     - Essential Supplies  
     - Safety Concern  

2. **Wearable Transmission**  
   - The wearable device (ESP32 + LoRa) packages a message containing:
     - Anonymized Device ID  
     - Alert Type  
     - Timestamp  
   - Sends it to a nearby LoRa base station

3. **Acknowledgment System**  
   - Base station sends an ACK signal back  
   - LED or vibration on the wearable confirms receipt

4. **Cloud Sync (When Online)**  
   - Base Station pushes received alerts to Firebase  
   - Flutter dashboard visualizes and tracks the alerts

5. **Cloud Sync (When Offline)**  
   - Base Station stores alerts locally  
   - Volunteers' phones connect via Bluetooth  
   - The VIRA app fetches messages to local storage  
   - Once internet is restored, phone syncs to Firebase

6. **Dashboard Functionality**  
   - Real-time alert list with filters (type, time, status)  
   - Alerts marked "active" until resolved  
   - Works on low-bandwidth networks

---

## Implementation Guide

### Prerequisites

- **Hardware:** ESP32 + RFM95 LoRa module, push buttons, LED, vibration motor, Li-ion battery  
- **Software:** Arduino IDE, Flutter SDK, Firebase account

---

### 1. Hardware Setup

- Connect LoRa module (SPI) to ESP32  
- Connect buttons to GPIO pins with pull-down resistors  
- Connect LED and vibration motor to digital pins via transistor control  
- Flash ESP32 with `sender.ino` or `receiver.ino` (based on role)

```cpp
// Upload the code from `esp32_lora_sender.ino` and `esp32_lora_receiver.ino`
```

---

### 2. Flutter App Setup

```bash
git clone https://github.com/DevikaSajith/Vira_dashboard.git
cd Vira_dashboard
flutter pub get
flutter run
```

> Ensure Firebase is set up (add your `google-services.json` or `firebase_options.dart`)

---

### 3. Firebase Setup

- Create a Firebase project  
- Enable Realtime Database  
- Add the web and Android app to Firebase  
- Update database rules (secure access)  
- Link the Firebase project in your Flutter app

---

### 4. Deployment

For web:
```bash
flutter build web
firebase deploy
```

---

## Challenges and Solutions

| Challenge                         | Solution                                                     |
|----------------------------------|--------------------------------------------------------------|
| LoRa reliability in dense areas  | Directional antennas, mesh networks for extended coverage    |
| Missed/delayed acknowledgments   | Retry logic with timeout and fallback indicators             |
| Power optimization               | ESP32 deep sleep + LED/vibration duty cycling                |
| Durability under cost constraints| ABS + IP65+ enclosure and modular design                     |

---

## Impact & Use Cases

### Immediate Impact

- Communication in disaster zones without network infrastructure  
- Helps women and vulnerable people seek help silently and safely  
- Reduces delay in emergency response and manual reporting  

### Future Scope

- Adapt for elderly/child tracking and assistance  
- Expand to district/state-level disaster alert mesh networks  
- Partner with NGOs and governments for scaled deployment  

---

## Team – FourLoops

- **Ayisha Sulaiman** – Hardware Developer  
  [https://github.com/Ayishacode](https://github.com/Ayishacode)

- **Jayalakshmy Jayakrishnan** – Hardware Developer  
  [https://github.com/JayalakshmyJayakrishnan](https://github.com/JayalakshmyJayakrishnan)

- **Devika P Sajith** – Flutter App & Firebase Developer  
  [https://github.com/DevikaSajith](https://github.com/DevikaSajith)

- **Pavithra Deepu E** – Backend Integration & Coordination  
  [https://github.com/pavithradeepue](https://github.com/pavithradeepue)

---

## Repositories

- **Hardware Code:** [https://github.com/DevikaSajith/Vira_hardware](https://github.com/DevikaSajith/Vira_hardware)  
- **Flutter App:** [https://github.com/DevikaSajith/Vira_dashboard](https://github.com/DevikaSajith/Vira_dashboard)  
- **Website:** [https://devikasajith.github.io/Vira_website](https://devikasajith.github.io/Vira_website)

---

## License

This project is released under the [MIT License](LICENSE).
