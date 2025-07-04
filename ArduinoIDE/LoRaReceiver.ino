#include <SPI.h>
#include <LoRa.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Firebase includes
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

/* WiFi credentials UPDATE INFO */
#define WIFI_SSID "UPDATE INFO"
#define WIFI_PASSWORD "UPDATE INFO"

/* Firebase config UPDATE INFO */
#define API_KEY "UPDATE INFO"
#define DATABASE_URL "UPDATE INFO"
#define USER_EMAIL "UPDATE INFO"
#define USER_PASSWORD "UPDATE INFO"

// Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

/* LoRa settings */
#define csPin     5
#define resetPin  14
#define irqPin    2

byte localAddress = 0xAA;   // This device's address [UPDATE INFO]
byte destination   = 0xBB;  // Sender's address

void setup() {
  Serial.begin(115200);
  while (!Serial);

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());

  // Firebase setup
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;
  Firebase.reconnectWiFi(true);
  Firebase.begin(&config, &auth);
  Serial.println("Firebase initialized.");

  // LoRa setup
  LoRa.setPins(csPin, resetPin, irqPin);
  if (!LoRa.begin(868E6)) {
    Serial.println("LoRa init failed.");
    while (true);
  }

  Serial.println("LoRa Receiver Ready");
}

void loop() {
  onReceive(LoRa.parsePacket());
}

void onReceive(int packetSize) {
  if (packetSize == 0) return;

  int recipient = LoRa.read();
  byte sender = LoRa.read();
  byte incomingMsgId = LoRa.read();
  byte incomingLength = LoRa.read();

  String incoming = "";
  while (LoRa.available()) {
    incoming += (char)LoRa.read();
  }

  if (recipient != localAddress && recipient != 0xFF) return;

  Serial.println("Message received: " + incoming);
  Serial.println("From: 0x" + String(sender, HEX));
  Serial.println("RSSI: " + String(LoRa.packetRssi()));
  Serial.println();

  // Push message to Firebase
  pushToFirebase(incoming);

  delay(1000);

  // Send ACK
  sendACK(sender);
}

void sendACK(byte recipientAddr) {
  String ack = "ACK";
  LoRa.beginPacket();
  LoRa.write(recipientAddr);
  LoRa.write(localAddress);
  LoRa.write(0);  // ACK ID
  LoRa.write(ack.length());
  LoRa.print(ack);
  LoRa.endPacket();
  Serial.println("ACK sent.");
}

void pushToFirebase(String msg) {
  String path = "/alertMessage";

  if (Firebase.RTDB.setString(&fbdo, path, msg)) {
    Serial.println("Message pushed to Firebase: " + msg);
  } else {
    Serial.print("Failed to push to Firebase: ");
    Serial.println(fbdo.errorReason());
  }
}
