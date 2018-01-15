# nodemcu-sonoff
Driving the [sonoff smart devices](https://www.itead.cc/smart-home.html) like [S20 Smart Socket](https://www.itead.cc/smart-home/smart-socket.html) without home automation.

This project is based on the nodemcu-httpserver.

It is a standalone solution to automate the sonoff smart devices.

It can be configured via its own web interface. Following functions are available:
- Switching On and Off directly
- Creating time schedules to switch On and Off at desired times (coming soon).
- Using the Hardware Button (if available) to switch On/Off.

Upcoming:
- switch relative to sunset / sunrise
- ...

Supported devices so far:
- S20 Smart Socket

## Installation
Install the nodemcu-httpserver and then just copy the files to the device and call
http://<My_Ip>/SonoffS20.html
