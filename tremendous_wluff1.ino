#include <Servo.h>

// #include <SPI.h>
// #include <MFRC522.h>

#define LED1 13
#define FOTOR A0
#define PIR 2
#define BUZZ 12
#define RST_PIN 9
#define SS_PIN 10
#define SERVO 11

Servo serv;
int sensorState = LOW;
int pirVal = 0;
int fotorInt = 0;
bool locked = true;
// MFRC522 rfid(SS_PIN, RST_PIN);
String KEY = "";

void setup()
{
    pinMode(LED1, OUTPUT);
    pinMode(BUZZ, OUTPUT);
    pinMode(PIR, INPUT);
    pinMode(FOTOR, INPUT);
	
  	serv.attach(SERVO);
  	serv.write(70);
  
  	// SPI.begin();
  	// rfid.PCD_Init();

    Serial.begin(9600);
}

/*
String readUID() {
  String readUID = "";
  for (byte i = 0; i < rfid.uid.size; i++) {
    readUID = readUID + (rfid.uid.uidByte[i] < 0x10 ? "0" : "");
    readUID = readUID + String(rfid.uid.uidByte[i], HEX);
  }
  return readUID;
}
*/

void loop()
{
  	// lectura del tag + validacion y buzzer
  	// if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
      // UID = readUID();
      // Serial.print("Tarjeta leida: ");
      // Serial.println(UID);

      // if (UID.substring(1) == KEY) {
        if (locked)
        {
    		serv.write(160);
            Serial.println("Puerta abierta");
          	locked = false;
        } else
        {
    		serv.write(70);
            Serial.println("Puerta cerrada");
          	locked = true;
        }
      /*
      } else {
        Serial.println("Tarjeta incorrecta");
        tone(BUZZ, 300, 250);
        delay(300);
        tone(BUZZ, 300, 250);
        delay(300);
        tone(BUZZ, 300, 250);
        delay(300);
      }
	  rfid.PICC_HaltA();
  	}
    */

    // sensor de luz y movimiento + activacion de luz led
    pirVal = digitalRead(PIR);
    fotorInt = analogRead(FOTOR);
    Serial.println(fotorInt);

    if (fotorInt > 300 && pirVal == HIGH)
    {
        digitalWrite(LED1, HIGH);
        if (sensorState == LOW)
        {
            Serial.println("Sensor activado");
            sensorState = HIGH;
        }
    }
    else
    {
        digitalWrite(LED1, LOW);
        if (sensorState == HIGH)
        {
            Serial.println("Sensor desactivado");
            sensorState = LOW;
        }
    }

    delay(1000);
}