/* MSP432 Twitter Client - a handheld MSP432 Twitter client!
 * Copyright (C) 2015 Albert Huang.
 * Based on various examples from Robert Wessels @ TI, LGPLv2.1.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "Energia.h"
// Include application, user and local libraries
#include <LCD_screen.h>
#include <LCD_screen_font.h>
#include <LCD_utilities.h>
#include <Screen_HX8353E.h>
#include <Terminal12e.h>
#include <Terminal6e.h>
#include <Terminal8e.h>

#include <SPI.h>
#include <WiFi.h>
#include <WiFiClient.h>

#include <Temboo.h>
#include "temboo_login.h" // Contains Temboo account information

// constants won't change. They're used here to 
// set pin numbers:
const int buttonOne = 33;     // the number of the pushbutton pin
const int buttonTwo = 32;     // the number of the pushbutton pin
const int ledGreen =  38;      // the number of the LED pin
const int ledBlue =  37;      // the number of the LED pin

WiFiClient client;
Screen_HX8353E myScreen;
int statusDone = 0;
char status[141] = { 0 };
char statusDisp[200] = { 0 };

void setup() {
  Serial.begin(9600);
  myScreen.begin();
  int wifiStatus = WL_IDLE_STATUS;

  myScreen.gText(0, myScreen.screenSizeY()-myScreen.fontSizeY(),
    "Checking for WiFi HW!");

  // Determine if the WiFi Shield is present
  Serial.print("\n\nShield:");
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("FAIL");
    myScreen.gText(0, myScreen.screenSizeY()-myScreen.fontSizeY(),
      "Fail WiFi");

    // If there's no WiFi shield, stop here
    while(true);
  }

  Serial.println("OK");
  myScreen.gText(0, myScreen.screenSizeY()-myScreen.fontSizeY(),
    "Connecting...");
  // Try to connect to the local WiFi network
  while(wifiStatus != WL_CONNECTED) {
    Serial.print("WiFi:");
    wifiStatus = WiFi.begin(WIFI_SSID);
    if (wifiStatus == WL_CONNECTED) {
      Serial.println("OK");
    } else {
      Serial.println("FAIL");
    }
    delay(5000);
  }
  myScreen.gText(0, myScreen.screenSizeY()-myScreen.fontSizeY(),
    "All done!");
  Serial.println("Setup complete.\n");
}

void loop() {
  strcpy("Status: ", statusDisp);
  strcat(statusDisp, status);
  myScreen.gText(0, myScreen.screenSizeY()-myScreen.fontSizeY(),
    statusDisp);
  if (statusDone == 1) {
    TembooChoreo StatusesUpdateChoreo(client);

    // Invoke the Temboo client
    StatusesUpdateChoreo.begin();

    // Set Temboo account credentials
    StatusesUpdateChoreo.setAccountName(TEMBOO_ACCOUNT);
    StatusesUpdateChoreo.setAppKeyName(TEMBOO_APP_KEY_NAME);
    StatusesUpdateChoreo.setAppKey(TEMBOO_APP_KEY);
  
    // Set Choreo inputs
    String AccessTokenValue = "3361531038-PfYFeP3r9ykZ9hZzWCcsaQp4AHSHAX0BcBbVQ2K";
    StatusesUpdateChoreo.addInput("AccessToken", AccessTokenValue);
    String AccessTokenSecretValue = "RzlVqDmPHKaD1L315bvJ2MqhKfJW7Zsr76YfkomuKrL2a";
    StatusesUpdateChoreo.addInput("AccessTokenSecret", AccessTokenSecretValue);
    String ConsumerSecretValue = "f1S7cqL2aJi3HVyFOnQ9wCihao0080OIQxm0rpp41AB1yc91xJ";
    StatusesUpdateChoreo.addInput("ConsumerSecret", ConsumerSecretValue);
    String StatusUpdateValue = "Testing 1, 2, 3 from Albert + Cameron, this time from the CC3100 + LaunchPad!";
    StatusesUpdateChoreo.addInput("StatusUpdate", StatusUpdateValue);
    String ConsumerKeyValue = "oa1pgd6ibazJFOa8X9Gp5BrmF";
    StatusesUpdateChoreo.addInput("ConsumerKey", ConsumerKeyValue);

    // Identify the Choreo to run
    StatusesUpdateChoreo.setChoreo("/Library/Twitter/Tweets/StatusesUpdate");

    // Run the Choreo; when results are available, print them to serial
    StatusesUpdateChoreo.run();
    
    while(StatusesUpdateChoreo.available()) {
      char c = StatusesUpdateChoreo.read();
      Serial.print(c);
    }
    StatusesUpdateChoreo.close();
  }
}
