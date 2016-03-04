
//
// Gyroscope bluetooth communication for Gyroflyer
// Hector Morlet
// Last revision September 2015
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
    mpu.setZAccelOffset(1733);

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
      // Resetting and getting interrupt status
      mpuInterrupt = false;
      mpuIntStatus = mpu.getIntStatus();

      // Getting current fifo count
      fifoCount = mpu.getFIFOCount();

      // Check for overflow - only if code is ineficient
      if ((mpuIntStatus & 0x10) || fifoCount == 1024) {
          // Reset to recover
            mpu.resetFIFO();
      } else if (mpuIntStatus & 0x02) {
          // Reading a packet from fifo
          mpu.getFIFOBytes(fifoBuffer, packetSize);

          // Adjusting fifo count for previous editions
          fifoCount -= packetSize;

          // Getting raw angles
          mpu.dmpGetQuaternion(&q, fifoBuffer);
          mpu.dmpGetGravity(&gravity, &q);
          mpu.dmpGetYawPitchRoll(angles, &q, &gravity);

          // Creating Euler angles
          float x = float(angles[1] * 180/M_PI);
          float z = float(angles[0] * 180/M_PI);
          float y = float(angles[2] * 180/M_PI);

          String dataToBeSent = (String(x) + " " + String(y) + " " + String(z));

          for (int i = 0; i < dataToBeSent.length(); i++) {
            Serial.write(dataToBeSent[i]);
          }
          Serial.println();

          mpu.resetFIFO();
          delay(100);
      }
}
