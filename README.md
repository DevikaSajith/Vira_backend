# VIRA – Voice. Impact. Relief. Access.

A gender-sensitive, offline-first emergency communication system using LoRa and Flutter for disaster resilience.

-----

## Table of Contents

  * [Project Overview](https://www.google.com/search?q=%23project-overview)
  * [Problem Statement](https://www.google.com/search?q=%23problem-statement)
  * [Live Links](https://www.google.com/search?q=%23live-links)
  * [Key Features](https://www.google.com/search?q=%23key-features)
  * [Tech Stack](https://www.google.com/search?q=%23tech-stack)
  * [System Architecture](https://www.google.com/search?q=%23system-architecture)
  * [Getting Started](https://www.google.com/search?q=%23getting-started)
  * [Challenges and Solutions](https://www.google.com/search?q=%23challenges-and-solutions)
  * [Impact and Future Scope](https://www.google.com/search?q=%23impact-and-future-scope)
  * [Team](https://www.google.com/search?q=%23team--fourloops)
  * [Repositories](https://www.google.com/search?q=%23repositories)
  * [License](https://www.google.com/search?q=%23license)

-----

## Project Overview

**VIRA (Voice. Impact. Relief. Access.)** is a low-cost, wearable emergency alert system designed for women and vulnerable communities in disaster-affected zones. It bridges the communication gap during crises where traditional mobile networks fail.

With just one press, users can silently send distress alerts over **LoRa** or **Bluetooth Mesh** to a base station. The alerts are visualized on a centralized **Flutter dashboard** used by NGOs and responders, enabling life-saving interventions.

-----

## Problem Statement

In emergency zones, women often face:

  * Unsafe conditions
  * Lack of medical aid and sanitation
  * No private channel to seek help

VIRA ensures silent, private, and **offline** distress communication for faster, safer relief.

-----

## Live Links

  * **App:** [https://vira-93d85.web.app](https://vira-93d85.web.app)
  * **Website:** [https://devikasajith.github.io/Vira\_website/](https://devikasajith.github.io/Vira_website/)

-----

## Key Features

  * One-touch emergency alert buttons for **medical**, **essentials**, and **safety** needs
  * Offline communication through **LoRa** or **Bluetooth Mesh**
  * **LED and vibration feedback** for real-time delivery acknowledgment
  * **ACK-based duplex system** to ensure delivery confirmation
  * Privacy-preserving system using anonymized Device IDs and optional NFC tags
  * **Firebase integration** for alert logging and analysis
  * **Flutter dashboard** for real-time tracking and resolution
  * Cost-effective design (\~₹1200/unit), scalable for humanitarian use

-----

## Tech Stack

### Hardware

  * ESP32 Microcontroller + LoRa (RFM95)
  * Waterproof wearable case (IP65+)
  * Rechargeable Li-ion battery (deep sleep optimized)
  * Three physical buttons (for alert types)
  * LED and vibration motor for delivery feedback

### Software

  * Embedded C++ firmware for ESP32 and LoRa modules
  * Flutter application for web/mobile dashboard
  * Firebase for backend and cloud data logging
  * Low-bandwidth dashboard design for emergency settings

-----

## System Architecture

VIRA is designed as an **offline-first**, duplex emergency communication system using LoRa.

### Communication Flow

1.  **User Interaction**

      * The user presses a dedicated button for Medical Help, Essential Supplies, or a Safety Concern.

2.  **Wearable Transmission**

      * The wearable device (ESP32 + LoRa) packages a message containing an Anonymized Device ID, Alert Type, and Timestamp.
      * It sends the message to a nearby LoRa base station.

3.  **Acknowledgment System**

      * The base station sends an ACK signal back to the wearable.
      * LED or vibration on the wearable confirms receipt.

4.  **Cloud Sync (When Online)**

      * The Base Station pushes received alerts to Firebase.
      * The Flutter dashboard visualizes and tracks the alerts in real-time.

5.  **Cloud Sync (When Offline)**

      * The Base Station stores alerts locally.
      * Volunteers' phones connect via Bluetooth, and the VIRA app fetches messages to local storage.
      * Once internet is restored, the phone automatically syncs the stored data to Firebase.

6.  **Dashboard Functionality**

      * Displays a real-time alert list with filters (type, time, status).
      * Alerts are marked "active" until they are resolved by a responder.
      * Designed to work on low-bandwidth networks.

-----

## Getting Started

### Prerequisites

  * **Hardware:** ESP32 + RFM95 LoRa module, push buttons, LED, vibration motor, Li-ion battery
  * **Software:** Arduino IDE, Flutter SDK, Firebase account

### 1\. Hardware Setup

1.  Connect the LoRa module (SPI) to the ESP32.
2.  Connect buttons to GPIO pins with pull-down resistors.
3.  Connect the LED and vibration motor to digital pins via transistor control.
4.  Flash the ESP32 with `sender.ino` or `receiver.ino` from the hardware repository, based on its role.
    ```cpp
    // Upload the code from `esp32_lora_sender.ino` and `esp32_lora_receiver.ino`
    ```

### 2\. Flutter App Setup

1.  Clone the repository:
    ```bash
    git clone https://github.com/DevikaSajith/Vira_dashboard.git
    cd Vira_dashboard
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app:
    ```bash
    flutter run
    ```

> **Note:** Ensure your Firebase project is set up and you have added your `google-services.json` (for Android) or `firebase_options.dart` (for web) file to the project.

### 3\. Firebase Setup

1.  Create a Firebase project.
2.  Enable Realtime Database.
3.  Add a web and/or Android app to your Firebase project.
4.  Update the database rules to ensure secure access.
5.  Link the Firebase project to your Flutter application as per the official documentation.

### 4\. Deployment

To deploy the Flutter dashboard to the web:

```bash
flutter build web
firebase deploy
```

-----

## Challenges and Solutions

| Challenge                        | Solution                                              |
| -------------------------------- | ----------------------------------------------------- |
| LoRa reliability in dense areas  | Directional antennas, mesh networks for extended coverage |
| Missed/delayed acknowledgments   | Retry logic with timeout and fallback indicators      |
| Power optimization               | ESP32 deep sleep + LED/vibration duty cycling         |
| Durability under cost constraints| ABS + IP65+ enclosure and modular design              |

-----

## Impact and Future Scope

### Immediate Impact

  * Enables communication in disaster zones without network infrastructure.
  * Helps women and vulnerable people seek help silently and safely.
  * Reduces delay in emergency response and manual reporting.

### Future Scope

  * Adapt the system for elderly/child tracking and assistance.
  * Expand to district or state-level disaster alert mesh networks.
  * Partner with NGOs and governments for scaled deployment.

-----

## Team – FourLoops

  * **Ayisha Sulaiman** – Hardware Developer
      * [https://github.com/Ayishacode](https://github.com/Ayishacode)
  * **Jayalakshmy Jayakrishnan** – Hardware Developer
      * [https://github.com/JayalakshmyJayakrishnan](https://github.com/JayalakshmyJayakrishnan)
  * **Devika P Sajith** – Flutter App & Firebase Developer
      * [https://github.com/DevikaSajith](https://github.com/DevikaSajith)
  * **Pavithra Deepu E** – Backend Integration & Coordination
      * [https://github.com/pavithradeepue](https://github.com/pavithradeepue)

-----

## Repositories

  * **Flutter App:** [https://github.com/DevikaSajith/Vira\_dashboard](https://github.com/DevikaSajith/Vira_dashboard)
  * **Website:** [https://devikasajith.github.io/Vira\_website](https://devikasajith.github.io/Vira_website)

-----

## License

This project is released under the MIT License.
