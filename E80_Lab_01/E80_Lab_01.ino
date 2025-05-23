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
<<<<<<< Updated upstream
  if (currentTime > 15000 && currentTime < 35000) {
    motorDriver.drive(255, 255, 0);  // Right Motor B and Left Motor
    // motorDriver.drive(120,0,0); //Added code Left Motor A
    // motorDriver.drive(0,0,120); //Added code Vertical Motor C
  } 
  else if (currentTime>35000 && currentTime < 55000) {
    motorDriver.drive(-255, -255, 0);

  }
=======
  if (currentTime > 4000) {
    motorDriver.drive(255, 255, 255);  // Right Motor B
    // motorDriver.drive(120,0,0); //Added code Left Motor A
    // motorDriver.drive(0,0,120); //Added code Vertical Motor C
  } 
>>>>>>> Stashed changes
  else {
    motorDriver.drive(0, 0, 0);
  }
  // For Obstacle Course

<<<<<<< Updated upstream
  //delay(120000);                   // 2mins delay for setup
  //motorDriver.drive(0, 0, -255);   // Go Down
  //delay(3000);                     // for 3 seconds
  //motorDriver.drive(255, 255, 0);  // Go Forward
  //delay(8000);                     // for 8 seconds
  //motorDriver.drive(0, 0, 255);    // Go UP
  //delay(5000);                     // for 5 seconds
  //motorDriver.drive(0, 0, 0);      //Stop
=======
       //Stop
>>>>>>> Stashed changes
  // DONT CHANGE CODE BELOW THIS LINE
  // --------------------------------------------------------------------------


  if (currentTime - printer.lastExecutionTime > LOOP_PERIOD) {
    printer.lastExecutionTime = currentTime;
    printer.printValue(0,adc.printSample());
    printer.printValue(1,logger.printState());
    printer.printValue(2, imu.printAccels());
    printer.printValue(3,motor_driver.printState());
    printer.printValue(4, imu.printRollPitchHeading());
    printer.printValue(5, motorDriver.printState());
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
