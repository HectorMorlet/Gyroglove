
//
// Gyroscope bluetooth communication for Gyroflyer
// Hector Morlet
// Last revision /10/2014
//


#include "I2Cdev.h"

#include "MPU6050_6Axis_MotionApps20.h"

#include "Wire.h"


MPU6050 mpu;

// MPU control/status vars
bool dmpReady = false;
// Interrupt status
uint8_t mpuIntStatus;
uint8_t doProceed;

// Wire 
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in fifo
uint8_t fifoBuffer[64]; // fifo storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]
VectorFloat gravity;    // [x, y, z]
float angles[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector



// ----------------------------------------------------------------
// |                 INTERRUPT DETECTION ROUTINE                  |
// ----------------------------------------------------------------

// Indicates whether MPU interrupt pin has gone high
volatile bool mpuInterrupt = false;
void dmpfifoReady() {
    mpuInterrupt = true;
}



// ----------------------------------------------------------------
// |                            SETUP                             |
// ----------------------------------------------------------------

void setup() {
    // Initializing Wire
    Wire.begin();
    TWBR = 24;

    // Initializing bluetooth
    Serial.begin(115200);

    // Initialize gyro
    mpu.initialize();

    // verify connection
    if (!mpu.testConnection()) return;

    // Initializing the DMP
    doProceed = mpu.dmpInitialize();

    // Magic offset values
    mpu.setXGyroOffset(220);
    mpu.setYGyroOffset(76);
    mpu.setZGyroOffset(-85);
    mpu.setZAccelOffset(1788);

    // Procceeding if this worked
    if (doProceed == 0) {
        // Turning on DMP
        mpu.setDMPEnabled(true);

        // Enabling interupt detection
        attachInterrupt(0, dmpfifoReady, RISING);
        mpuIntStatus = mpu.getIntStatus();

        // DMP ready to go
        dmpReady = true;

        // Getting packet size for use
        packetSize = mpu.dmpGetFIFOPacketSize();
    } else {
        // Error
        Serial.print(F("DMP Initialization failed (code "));
        
        // 1 = initial memory load failed
        // 2 = DMP configuration updates failed
        Serial.print(doProceed);
        Serial.println(F(")"));
    }
}



// ----------------------------------------------------------------
// |                             Update                           |
// ----------------------------------------------------------------

int isPrimed = 0;
int activeBufferLength = 0;

struct XYZ {
  int x;
  int y;
  int z;
};

XYZ coordinateBuffer[20];

void loop() {
    while (1) {

      // Resetting and getting interrupt status
      mpuInterrupt = false;
      mpuIntStatus = mpu.getIntStatus();
  
      // Getting current fifo count
      fifoCount = mpu.getFIFOCount();
      
      if (!isPrimed) {
        Serial.write(' ');
      }
  
      // Check for overflow - only if code is ineficient
      if ((mpuIntStatus & 0x10) || fifoCount == 1024) {
          // Reset to recover
          Serial.println("FIFO FULL!");
          mpu.resetFIFO();
  //        Serial.println(F("fifo overflow!"));
      } else if (mpuIntStatus & 0x02) {
          // Getting the fifo count
          Serial.println("GETTTING FIFO");
          while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();
          
          Serial.println("GET FIFBYTES");
          // Reading a packet from fifo
          mpu.getFIFOBytes(fifoBuffer, packetSize);
          
          // Adjusting fifo count for previous editions
          fifoCount -= packetSize;
  
          // Getting raw angles
          Serial.println("QURT");
          mpu.dmpGetQuaternion(&q, fifoBuffer);
          Serial.println("GRAVITYSCROORE");
          mpu.dmpGetGravity(&gravity, &q);
          Serial.println("PITCH");
          mpu.dmpGetYawPitchRoll(angles, &q, &gravity);
          Serial.println("ANGLES");
          
          // Creating Eulor angles
          int x = int(angles[1] * 180/M_PI);
          int z = int(angles[0] * 180/M_PI);
          int y = int(angles[2] * 180/M_PI);
          
          XYZ addingCoords = {x, y, z};
          
          activeBufferLength++;
          coordinateBuffer[activeBufferLength] = addingCoords;
          
      }
      
      if (activeBufferLength > 10) {
          XYZ coords = coordinateBuffer[activeBufferLength];
          String dataToBeSent = (String(coords.x) + " " + String(coords.y) + " " + String(coords.z));
          
          for (int i = 0; i < dataToBeSent.length(); i++) {
            Serial.write(dataToBeSent[i]);
          }
          Serial.println(); 
          
          isPrimed = 1;
          
          activeBufferLength = 0;
      }
}
}
