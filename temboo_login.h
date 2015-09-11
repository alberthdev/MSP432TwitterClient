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

/*
IMPORTANT NOTE about TembooAccount.h

TembooAccount.h contains your Temboo account information and must be included
alongside your sketch. To do so, make a new tab in Energia, call it TembooAccount.h,
and copy this content into it. 
*/

#define TEMBOO_ACCOUNT "::INSERT_TEMBOO_ACCOUNT::"  // Your Temboo account name 
#define TEMBOO_APP_KEY_NAME "::INSERT_TEMBOO_APP_KEY_NAME::"  // Your Temboo app name
#define TEMBOO_APP_KEY "::INSERT_TEMBOO_APP_KEY::"  // Your Temboo app key

#define WIFI_SSID "::INSERT_WIFI_SSID::"
#define WPA_PASSWORD "::INSERT_WPA_PASSWORD::"
#define WEP_KEY "::INSERT_WEP_KEY::"
#define WEP_KEY_INDEX ::INSERT_WEP_KEY_INDEX::

// Choreo Twitter Login Information
#define CHOREO_ACCESS_TOKEN_VALUE "::INSERT_CHOREO_ACCESS_TOKEN_VALUE::"
#define CHOREO_ACCESS_TOKEN_SECRET_VALUE "::INSERT_CHOREO_ACCESS_TOKEN_SECRET_VALUE::";
#define CHOREO_CONSUMER_SECRET_VALUE "::INSERT_CHOREO_CONSUMER_SECRET_VALUE::";
#define CHOREO_STATUS_UPDATE_VALUE "::INSERT_CHOREO_STATUS_UPDATE_VALUE::";
#define CHOREO_CONSUMER_KEY_VALUE "::INSERT_CHOREO_CONSUMER_KEY_VALUE::";

/* 
The same TembooAccount.h file settings can be used for all Temboo sketches.

Keeping your account information in a separate file means you can share the 
main .ino file without worrying that you forgot to delete your credentials.
*/
