#include <Wire.h>
#include <BleGamepad.h> 

BleGamepad bleGamepad("BLE Balance Board", "Pedro", 100);

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

void setup() {
  Serial.begin(115200);
  Serial.println("Configure Wire");
  
  Wire.setPins(21,22);
  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission(true);
  
  Serial.println("Configure BLE");
  
  BleGamepadConfiguration bleGamepadConfig;
  
  bleGamepadConfig.setAutoReport(false);
  bleGamepadConfig.setControllerType(CONTROLLER_TYPE_JOYSTICK); 
  bleGamepadConfig.setButtonCount(0);
  bleGamepadConfig.setWhichAxes(true,true,false,false,false,false,false,false);

  bleGamepad.begin(&bleGamepadConfig);
  
  Serial.println("Start");
  Serial.println("-----------------------------------------");
}

void loop() {
  if (bleGamepad.isConnected()) {
    Wire.beginTransmission(MPU_addr);
    Wire.write(0x3B);
    Wire.endTransmission(false);
    Wire.requestFrom(MPU_addr,14,true);
    AcX = Wire.read()<<8|Wire.read();
    AcY = Wire.read()<<8|Wire.read();
    AcZ = Wire.read()<<8|Wire.read();
    int xAng = map(AcX,minVal,maxVal,-90,90);
    int yAng = map(AcY,minVal,maxVal,-90,90);
    int zAng = map(AcZ,minVal,maxVal,-90,90);
     
    x= RAD_TO_DEG * (atan2(-yAng, -zAng)+PI);
    y= RAD_TO_DEG * (atan2(-xAng, -zAng)+PI);
    z= RAD_TO_DEG * (atan2(-yAng, -xAng)+PI);
    
    if (x > 180) { x -= 360; }
  
    if (y > 180) { y -= 360; }
  
    if (z > 180) { z -= 360; }
  
    float vx = x / max_angle;
    if (vx > 1) { vx = 1; } else if (vx < -1) { vx = -1; }
    int rx = (int)(vx * max_value);
    float vy = y / max_angle;
    if (vy > 1) { vy = 1; } else if (vy < -1) { vy = -1; }
    int ry = (int)(vy * max_value);
    
    bleGamepad.setAxes(rx, ry);
    bleGamepad.sendReport();

    Serial.print("AngleX= ");
    Serial.println(x);
    Serial.print("ValueX= ");
    Serial.println(vx);
    Serial.print("ResultX= ");
    Serial.println(rx);
     
    Serial.print("AngleY= ");
    Serial.println(y);
    Serial.print("ValueY= ");
    Serial.println(vy);
    Serial.print("ResultY= ");
    Serial.println(ry);

    Serial.println("-----------------------------------------");

    delay(time_delay);
  } else {
    delay(time_delay/10);
  }
  
}
