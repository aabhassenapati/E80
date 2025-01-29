/********
Default E80 Code
Current Author:
    Wilson Ives (wives@g.hmc.edu) '20 (contributed in 2018)
Previous Contributors:
    Christopher McElroy (cmcelroy@g.hmc.edu) '19 (contributed in 2017)  
    Josephine Wong (jowong@hmc.edu) '18 (contributed in 2016)
    Apoorva Sharma (asharma@hmc.edu) '17 (contributed in 2016)                    
*/

/* Libraries */

// general
#include <Arduino.h>
#include <Wire.h>
#include <Pinouts.h>

// E80-specific
#include <SensorIMU.h>
#include <MotorDriver.h>
#include <Logger.h>
#include <Printer.h>


/* Global Variables */

// period in ms of logger and printer
#define LOOP_PERIOD 100  //.1 secs

// Motors
MotorDriver motorDriver;

// IMU
SensorIMU imu;

// Logger
Logger logger;
bool keepLogging = true;

// Printer
Printer printer;

// loop start recorder
int loopStartTime;

void setup() {
  printer.init();

  /* Initialize the Logger */
  logger.include(&imu);
  logger.include(&motorDriver);
  logger.init();

  /* Initialise the sensors */
  imu.init();

  /* Initialize motor pins */
  motorDriver.init();

  /* Keep track of time */
  printer.printMessage("Starting main loop", 10);
  loopStartTime = millis();

  // motorDriver.drive(0, 0, -255);
  // delay(5000);
  //motorDriver.drive(255, 0, 0);
  //delay(1000);
  //motorDriver.drive(0, 255, 0);
  //delay(1000);
  /*
  delay(35000);
  motorDriver.drive(0, 0, 255);   // Go Down
  delay(4000);                     // for 3 seconds
  motorDriver.drive(-210, -255, 0);  // Go Forward
  delay(4000);                     // for 8 seconds
  motorDriver.drive(0, 0, -255);    // Go UP
  delay(5000);                     // for 5 seconds
  motorDriver.drive(0, 0, 0);      //Stop 8 
 */ 
}


void loop() {

  int currentTime = millis() - loopStartTime;

  ///////////  Don't change code above here! ////////////////////
  // write code here to make the robot fire its motors in the sequence specified in the lab manual
  // the currentTime variable contains the number of ms since the robot was turned on
  // The motorDriver.drive function takes in 3 inputs arguments motorA_power, motorB_power, motorC_power:
  //       void motorDriver.drive(int motorA_power,int motorB_power,int motorC_power);
  // the value of motorX_power can range from -255 to 255, and sets the PWM applied to the motor
  // The following example will turn on motor B for four seconds between seconds 4 and 8
  // if (currentTime > 4000 && currentTime < 8000) {
  //   motorDriver.drive(0, 120, 0);  // Right Motor B
  //   // motorDriver.drive(120,0,0); //Added code Left Motor A
  //   // motorDriver.drive(0,0,120); //Added code Vertical Motor C
  // } else {
  //   motorDriver.drive(0, 0, 0);
  // }
  // For Obstacle Course
 


  if (currentTime > 35000 && currentTime < 38000)
  {
  motorDriver.drive(0, 0, 255); // Go Down 3 secs
  }
  if (currentTime > 38000 && currentTime < 42000)
  {
  motorDriver.drive(-210, -255, 0); // Go Forward 4 secs, left motor is little fast so slow it down
  }
  if (currentTime > 42000 && currentTime < 47000)
  {
  motorDriver.drive(0, 0, -255); //Go Up 5 secs
  }
  else {
    motorDriver.drive(0, 0, 0);
  }

  // DONT CHANGE CODE BELOW THIS LINE
  // --------------------------------------------------------------------------


  if (currentTime - printer.lastExecutionTime > LOOP_PERIOD) {
    printer.lastExecutionTime = currentTime;
    printer.printValue(0, imu.printAccels());
    printer.printValue(1, imu.printRollPitchHeading());
    printer.printValue(2, motorDriver.printState());
    printer.printToSerial();  // To stop printing, just comment this line out
  }

  if (currentTime - imu.lastExecutionTime > LOOP_PERIOD) {
    imu.lastExecutionTime = currentTime;
    imu.read();  // this is a sequence of blocking I2C read calls
  }

  if (currentTime - logger.lastExecutionTime > LOOP_PERIOD && logger.keepLogging) {
    logger.lastExecutionTime = currentTime;
    logger.log();
  }
}
