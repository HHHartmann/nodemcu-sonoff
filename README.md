# nodemcu-sonoff
driving the sonoff smart devices like S20 without home automation

This project is based on the nodemcu-httpserver.

It is a standalone solution to automate the sonoff smart devices.

It is configured via its own web interface. Following functions are available:
- Switching On and Off directly
- Creating time schedules to switch On and Off at desired times.
- Usinf the Hardware Button (if available) to switch On/Off.

Supported devices so far:
- S20 smart plug

## Installation
Install the nodemcu-httpserver and then just copy the files to the device and call
http://<My_Ip>/SonoffS20.html
