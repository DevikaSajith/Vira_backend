#include <SPI.h>
#include <LoRa.h>

#define csPin     5
#define resetPin  14
#define irqPin    2

#define BUTTON_HELP    25
#define BUTTON_SUPPLY  26
#define LED_PIN        33

byte localAddress = 0xBB;   // This device's address
byte destination   = 0xAA;  // Receiver's address
byte msgCount = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial);

  pinMode(BUTTON_HELP, INPUT_PULLUP);
  pinMode(BUTTON_SUPPLY, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  LoRa.setPins(csPin, resetPin, irqPin);

  if (!LoRa.begin(868E6)) {
    Serial.println("LoRa init failed.");
    while (true);
  }

  Serial.println("LoRa Sender Ready");
}

void loop() {
  if (digitalRead(BUTTON_HELP) == LOW) {
    sendMessage("HELP NEEDED ");
    delay(1000);
  }

  if (digitalRead(BUTTON_SUPPLY) == LOW) {
    sendMessage("EMERGENCY SUPPLIES NEEDED");
    delay(1000);
  }

  onReceive(LoRa.parsePacket());
}

void sendMessage(String message) {
  LoRa.beginPacket();
  LoRa.write(destination);
  LoRa.write(localAddress);
  LoRa.write(msgCount++);
  LoRa.write(message.length());
  LoRa.print(message);
  LoRa.endPacket();

  Serial.println("Message sent: " + message);
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

  if (incoming == "ACK") {
    Serial.println("ACK received from receiver!");
    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
  }
}
