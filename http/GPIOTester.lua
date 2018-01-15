pins = {}
pins.green = 7
pins.switch = 3
pins.relay = 6
pins.send = 10

local function setPin(pin, value)
   gpio.write(pin, value)
   gpio.mode(pin, gpio.OUTPUT, gpio.FLOAT)
end


local function readDoorStatus(pin)
   -- When the garage door is closed, the reed relay closes, grounding the pin and causing us to read low (0).
   -- When the garage door is open, the reed relay is open, so due to pullup we read high (1).
   gpio.write(pin, gpio.HIGH)
   gpio.mode(pin, gpio.INPUT, gpio.PULLUP)
   if gpio.read(pin) == 1 then return 'open' else return 'closed' end
end


local function sendResponse(connection, httpCode, errorCode, action, pin, message)

   -- Handle nil inputs
   if action == nil then action = '' end
   if pin == nil then
      pin = 1
   end
   if message == nil then message = '' end

   connection:send("HTTP/1.0 "..httpCode.." OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
   connection:send('{"error":'..errorCode..', "pin":'..pin..', "action":"'..action..'", "message":"'..message..'"}')
end


local function sendStatus(connection, pin)
   connection:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
   connection:send('{"error":0, "pin":'..pin..', "action":"status"'..', "status":"'..readDoorStatus(pin)..'"}')
end


local function openDoor(pin)
   -- errors if door is already open.
   setPin(pin, gpio.HIGH)
   return true
end


local function closeDoor(pin)
   setPin(pin, gpio.LOW)
   return true
end


return function (connection, req, args)

   -- Make this work with both GET and POST methods.
   -- In the POST case, we need to extract the arguments.
   print("method is " .. req.method)
   local rd = req.getRequestData()

      for name, value in pairs(rd) do
         args[name] = value
      end
   -- validate door input

   if args.pin == nil then
      sendResponse(connection, 400, -1, args.action, args.pin, "No pin specified")
      return
   end

   -- perform action

   if args.action == "open" then
      if(openDoor(args.pin)) then
         sendResponse(connection, 200, 0, args.action, args.pin, "Door opened")
      else
         sendResponse(connection, 400, -3, args.action, args.pin, "Door is already open")
      end
      return
   end

   if args.action == "close" then
      if(closeDoor(args.pin)) then
         sendResponse(connection, 200, 0, args.action, args.pin, "Door closed")
      else
         sendResponse(connection, 400, -4, args.action, args.pin, "Door is already closed")
      end
      return
   end

   if args.action == "status" then
      sendStatus(connection, args.pin)
      return
   end

   -- everything else is error

   sendResponse(connection, 400, -5, args.action, args.pin, "Bad action")

end
