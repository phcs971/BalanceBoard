#include <ArduinoJson.h>
#include <Wire.h>
#include <sstream>
#include <string>
#include <NimBLEDevice.h>
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"

static NimBLEServer* pServer;
StaticJsonDocument<256> doc;
JsonObject angle;
JsonObject acc;
JsonObject gyro;

bool isNotifing = false;
bool hasConnection = false;

const int MPU_addr=0x68;
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;
 
int minVal=265;
int maxVal=402;
 
double x;
double y;
double z;

#define time_delay 100
#define max_angle 20
#define max_value 32767

class ServerCallbacks: public NimBLEServerCallbacks {
    void onConnect(NimBLEServer* pServer) { 
      hasConnection = true;  
    };

    void onConnect(NimBLEServer* pServer, ble_gap_conn_desc* desc) {
      hasConnection = true;
      pServer->updateConnParams(desc->conn_handle, 24, 48, 0, 60);
    };
    
    void onDisconnect(NimBLEServer* pServer) {
      hasConnection = false;
      NimBLEDevice::startAdvertising();
    };
    
    void onMTUChange(uint16_t MTU, ble_gap_conn_desc* desc) { };

    /********************* Security handled here **********************/
    uint32_t onPassKeyRequest() { return 123456; };

    bool onConfirmPIN(uint32_t pass_key) { return true; };

    void onAuthenticationComplete(ble_gap_conn_desc* desc) {
        if (!desc->sec_state.encrypted) {
            NimBLEDevice::getServer()->disconnect(desc->conn_handle);
            return;
        }
    };
};

/** Handler class for characteristic actions */
class CharacteristicCallbacks: public NimBLECharacteristicCallbacks {
    void onRead(NimBLECharacteristic* pCharacteristic) { };

    void onWrite(NimBLECharacteristic* pCharacteristic) { };
    
    void onNotify(NimBLECharacteristic* pCharacteristic) { };

    void onStatus(NimBLECharacteristic* pCharacteristic, Status status, int code) { };

    void onSubscribe(NimBLECharacteristic* pCharacteristic, ble_gap_conn_desc* desc, uint16_t subValue) {
      String uuid = std::string(pCharacteristic->getUUID()).c_str();
      if (uuid == "0xa001") {
        if (subValue == 0) {
          isNotifing = false;
        } else {
          isNotifing = true;
        }
      }
    };
};

class DescriptorCallbacks : public NimBLEDescriptorCallbacks {
    void onWrite(NimBLEDescriptor* pDescriptor) { };

    void onRead(NimBLEDescriptor* pDescriptor) { };
};

static CharacteristicCallbacks chrCallbacks;
static DescriptorCallbacks descCallbacks;
static NimBLECharacteristic* pChar;

int LED_BUILTIN = 2;

void blink(int t) {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(t);
  digitalWrite(LED_BUILTIN, LOW);
  delay(t);
}

void blink() {
 blink(100);
}

void setup() {
    Serial.begin(115200);
    WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  
    pinMode(LED_BUILTIN, OUTPUT);
    delay(100);

    blink();
    blink();
    
    NimBLEDevice::setPower(ESP_PWR_LVL_N12);
    NimBLEDevice::init("BLE Balance Board");
    NimBLEDevice::setSecurityAuth(BLE_SM_PAIR_AUTHREQ_SC);

    pServer = NimBLEDevice::createServer();
    pServer->setCallbacks(new ServerCallbacks());

    NimBLEService* pService = pServer->createService("DA1A");
    pChar = pService->createCharacteristic(
       "A001",
       NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::READ_ENC | NIMBLE_PROPERTY::NOTIFY
    );
  
    pChar->setValue("{x:0, y: 0}");
    pChar->setCallbacks(&chrCallbacks);

    
    pService->start();

    NimBLEAdvertising* pAdvertising = NimBLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(pService->getUUID());
    pAdvertising->setScanResponse(false);
    pAdvertising->start();

    blink();
    blink();
        
    Wire.setPins(21,22);
    Wire.begin();
    Wire.beginTransmission(MPU_addr);
    Wire.write(0x6B);
    Wire.write(0);
    Wire.endTransmission(true);
    
    blink();
    blink();

    angle = doc.createNestedObject("angle");
    acc = doc.createNestedObject("acc");
    gyro = doc.createNestedObject("gyro");
}


void loop() {
  if (hasConnection) {
    if (isNotifing) {
      blink();
      blink();
      
      Wire.beginTransmission(MPU_addr);
      Wire.write(0x3B);
      Wire.endTransmission(false);
      Wire.requestFrom(MPU_addr,14,true);
      AcX = Wire.read()<<8|Wire.read();
      AcY = Wire.read()<<8|Wire.read();
      AcZ = Wire.read()<<8|Wire.read();
      Tmp = Wire.read()<<8|Wire.read();
      GyX = Wire.read()<<8|Wire.read();
      GyY = Wire.read()<<8|Wire.read();
      GyZ = Wire.read()<<8|Wire.read();
      int xAng = map(AcX,minVal,maxVal,-90,90);
      int yAng = map(AcY,minVal,maxVal,-90,90);
      int zAng = map(AcZ,minVal,maxVal,-90,90);
       
      x= RAD_TO_DEG * (atan2(-yAng, -zAng)+PI);
      y= RAD_TO_DEG * (atan2(-xAng, -zAng)+PI);
      z= RAD_TO_DEG * (atan2(-yAng, -xAng)+PI);
      
      if (x > 180) { x -= 360; }
    
      if (y > 180) { y -= 360; }
    
      if (z > 180) { z -= 360; }

      angle["x"] = x;
      angle["y"] = y;
      angle["z"] = z;
      acc["x"] = AcX/16384.00;
      acc["y"] = AcY/16384.00;
      acc["z"] = AcZ/16384.00;
      gyro["x"] = GyX/131.00;
      gyro["y"] = GyY/131.00;
      gyro["z"] = GyZ/131.00;
      doc["temp"] = Tmp/340.00+36.53;
      
      std::string result;
      serializeJson(doc, result);
      Serial.println(result.c_str());
  
      pChar->setValue(result);
      pChar->notify();
    }
    digitalWrite(LED_BUILTIN, HIGH);
    delay(time_delay);
  } else {
    blink();
    delay(200);
    blink();
    delay(200);
  }
  
}
