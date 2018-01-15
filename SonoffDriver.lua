local driver = {}


local pins = {}
pins.green = 7
pins.button = 3
pins.relay = 6
pins.send = 10

if (S20Status == nil) then
   S20Status = {}
   S20Status.pinValue = {}
end

local function setPin(pin, value)
   gpio.write(pin, value)
   gpio.mode(pin, gpio.OUTPUT, gpio.FLOAT)
   S20Status.pinValue[pin] = value
end

local function pinValue(pin)
   return S20Status.pinValue[pin]
end

local function readPin(pin)
   gpio.write(pin, gpio.HIGH)
   gpio.mode(pin, gpio.INPUT, gpio.PULLUP)
   S20Status.pinValue[pin] = nil
   return gpio.read(pin)
end

function driver.CloseRelay()
   setPin(pins.relay, gpio.HIGH)
end

function driver.OpenRelay()
   setPin(pins.relay, gpio.LOW)
end

function driver.RelayOpen()
   return pinValue(pins.relay) == gpio.LOW
end

function driver.ToggleRelay()
   if (driver.RelayOpen()) then
      driver.CloseRelay()
   else
      driver.OpenRelay()
   end
end

function driver.LedOn()
   pwm.close(pins.green)
   setPin(pins.relay, gpio.LOW)
end

function driver.LedOff()
   pwm.close(pins.green)
   setPin(pins.relay, gpio.HIGH)
end

function driver.LedBlink(freq, duty)
   pwm.setup(pins.green, freq, duty)
   pwm.start(pins.green)
end

function driver.GetButtonState()
   return readPin(pins.button)
end

function driver.SetButtonCallback(trigger, cb)
   pwm.close(pins.button)
   gpio.mode(pins.button, gpio.INT, gpio.PULLUP)
   gpio.trig(pins.button, trigger, cb)
end

function driver.GetUpcomingEvents()

   local f = file.open("http/Sonoff-Rules.json", "r")
   if (f == nil) then return {} end
   local decoder = sjson.decoder()
   local buf = f:read()
   while buf ~= nil do
      decoder:write(buf)
      buf = f:read()
   end
   f:close()
   local rules = decoder:result()
   decoder = nil
   collectgarbage()
   
   local result = {}
   local i,v
   for i,v in pairs(rules) do
      tabel.insert(result, {v.time, v.action})
   end
   return result
end

return driver
