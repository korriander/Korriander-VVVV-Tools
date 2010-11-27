
// Values needed to receive serial Messages  
int inputByte = 0;	// one incoming Byte.
int receiveMessage[9]; // the message when received in void filltable()
int validNewMessage[9]; // message gets stored here if value is valid
int readState = 1; // kind of state automata needed to receive the messages.
int didReceive = 0; // indicates wether if a new message was received.

// Values needed to write Outputs
int pwmOutPin[6] = {
  3,5,6,9,10,11};
int digitalOutPin[3] = {
  8,12,13};
boolean DigitalValue=LOW;


// Values needed to read Sensors
int analogInputPin[6] = {
  0,1,2,3,4,5};
int digitalInputPin[3] = {
  2,4,7};
int sensorValues[9] = {
  0};


// debug values


void setup() 
{ 
  // Setup serial Communication 
  Serial.begin(115200); 

  // Setup Pin modes

  // Set Outputs
  // Output Analog
  for (int i=0;i<6;i++) {
    pinMode(pwmOutPin[i], OUTPUT);
    digitalWrite(pwmOutPin[i], LOW);
  }

  // Output Digital
  for (int i=0;i<3;i++) {
    pinMode(digitalOutPin[i], OUTPUT);
    digitalWrite(digitalOutPin[i], LOW);
  }


  // Set Inputs
  // Input Analog. To use them as GPIO uncomment the area above.
  /*
  for (int i=0;i<6;i++) {
   pinMode(analogInputPin[i], OUTPUT);
   digitalWrite(analogInputPin[i], HIGH);
   }
   */

  // Input Digital, with internal Pullup enabled
  for (int i=0;i<3;i++) {
    pinMode(digitalInputPin[i], INPUT);
    digitalWrite(digitalInputPin[i], HIGH);       // turn on pullup resistors, uncomment to disable pullup
  }
} 


void loop() 
{ 
  //Receive Serial Values
  serialReceive();

  //Output received Values
  outputValues();

  //Read Sensors
  readSensors();

  //Send Sensors
  if (didReceive > 0)
    sendSensors();

} 



void serialReceive()
{

  if(Serial.available()>12) 
  {
    do
    { 
      if(Serial.available()>0)   
        inputByte = Serial.read();

      if (readState == 1 && inputByte == 13) // carriage Return
      {
        readState = 2;
      }

      else if (readState == 2 && inputByte == 10) // LineFeed
      {
        readState = 3;
      }

      else if (readState == 3 && inputByte == 64 && Serial.available()>9) // @ = 64 in ASCII + we have a full table to read now
      {
        for(int i=0; i<9; i++)
        {
          receiveMessage[i]=Serial.read();
        } 
        readState = 4;
      }

      else if (readState == 4 && inputByte == 36) // $ = 36 in ASCII
      { 
        for(int i=0; i<9; i++)
        {
          validNewMessage[i] = receiveMessage[i];
        }
        didReceive = 1;
        readState = 5;
      }

      else 
      {
        for(int i=0; i<Serial.available();)
        {
          inputByte=Serial.read();
          if(inputByte == 36)
            break;
        }
        readState=6;
      }
    }
    while(readState<5);
    readState = 1 ;
  }
}


void outputValues()
{
  for(int i = 0; i<6; i++)
    analogWrite(pwmOutPin[i], validNewMessage[i]);

  for(int i = 0; i<3; i++)
  {
    if (validNewMessage[i+6] < 120)
      digitalWrite(digitalOutPin[i], LOW);
    else
      digitalWrite(digitalOutPin[i], HIGH);
  }
}


void readSensors()
{
  for(int i = 0; i<6; i++)
    sensorValues[i] = analogRead(analogInputPin[i]);

  for(int i = 0; i<3; i++)
    sensorValues[i+6] = digitalRead(digitalInputPin[i]); 
}



void sendSensors()
{

  Serial.print("@");
  for (int i=0; i<9; i++)
  {
    Serial.print(sensorValues[i], DEC);
    Serial.print("|");
  }
  Serial.print("$");
  Serial.print(13, BYTE);
  Serial.print(10, BYTE);

  didReceive = 0; // change back did Receive
}

