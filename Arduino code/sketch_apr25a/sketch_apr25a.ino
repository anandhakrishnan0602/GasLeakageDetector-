#include <ESP8266WiFi.h>
#include <Arduino.h>
#include <Firebase_ESP_Client.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <SoftwareSerial.h>

SoftwareSerial mySerial(D5, D6);

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"


const char *ssid = "realme"; // replace with your wifi ssid and wpa2 key
const char *pass = "12345678";
#define API_KEY "AIzaSyBb1bRQPTDyuuGrt7sSfvd8KC2xwMlxERI"

#define USER_EMAIL "abcd@gmail.com"
#define USER_PASSWORD "123456"

#define DATABASE_URL "https://gas-leakage-detector-548e1-default-rtdb.asia-southeast1.firebasedatabase.app/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
String uid;
String databasePath;
String tempPath = "/temperature";
String timePath = "/timestamp";
String parentPath;

// Define NTP Client to get time
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

int timestamp;

FirebaseJson json;

unsigned long sendDataPrevMillis = 0;
unsigned long timerDelay = 1500;

// Function that gets current epoch time
unsigned long getTime() {
  timeClient.update();
  unsigned long now = timeClient.getEpochTime();
  return now;
}

WiFiClient client;
void setup()
{
mySerial.begin(9600);
Serial.begin(115200);
delay(10);
Serial.println("Connecting to ");
Serial.println(ssid);
WiFi.begin(ssid, pass);
while (WiFi.status() != WL_CONNECTED)
{
delay(500);
Serial.print(".");
}
Serial.println("");
Serial.println("WiFi connected");

timeClient.begin();
config.api_key = API_KEY;
auth.user.email = USER_EMAIL;
auth.user.password = USER_PASSWORD;
config.database_url = DATABASE_URL;

Firebase.reconnectWiFi(true);
fbdo.setResponseSize(4096);
 
// Assign the callback function for the long running token generation task
config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

// Assign the maximum retry of token generation
config.max_token_generation_retry = 5;

Firebase.begin(&config, &auth);

// Getting the user UID might take a few seconds
Serial.println("Getting User UID");
while ((auth.token.uid) == "") {
  Serial.print('.');
  delay(1000);
}

uid = auth.token.uid.c_str();
Serial.print("User UID: ");
Serial.print(uid);
databasePath = "/UsersData/" + uid + "/readings";

}
void loop()
{
float h = analogRead(A0);
if (isnan(h))
{
Serial.println("Failed to read from MQ-5 sensor!");
return;
}
if(h>400)
{
  SendMessage();
  Serial.print("Sms Send");
  delay(10000);

}
 
if (Firebase.ready() && (millis() - sendDataPrevMillis > timerDelay || sendDataPrevMillis == 0))
{
  sendDataPrevMillis = millis();

  //Get current timestamp
timestamp = getTime();
Serial.print ("time: ");
Serial.println (timestamp);
parentPath= databasePath + "/" + String(timestamp);
json.set(tempPath.c_str(), String(h));
json.set(timePath, String(timestamp));
Serial.printf("Set json... %s\n", Firebase.RTDB.setJSON(&fbdo, parentPath.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
}
}

void SendMessage()
{
Serial.println("I am in send");
mySerial.println("AT+CMGF=1"); //Sets the GSM Module in Text Mode
delay(1000); // Delay of 1000 milli seconds or 1 second
mySerial.println("AT+CMGS=\"+919497406602\"\r"); // Replace x with mobile number
delay(1000);
mySerial.println("Excess Gas Detected. Open Windows");// The SMS text you want to send
delay(100);
mySerial.println((char)26);// ASCII code of CTRL+Z
delay(1000);
}
