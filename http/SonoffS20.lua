local context = {}

local function sendOK(connection, httpCode, errorCode, action, pin, message)

   dofile("httpserver-header.lc")(context.connection, 200, 'json')

   context.connection:send('{"error":0}')
end


local function sendStatus(status)
   dofile("httpserver-header.lc")(context.connection, 200, 'json')

   context.connection:send('{"error":0, "status":"'..status..'"}')
end

local controller = {}

function controller.on()
   context.driver.CloseRelay()
   sendOK()
end

function controller.off()
   context.driver.OpenRelay()
   sendOK()
end

function controller.status()
   local status
   if context.driver.RelayOpen() then
      status = "off"
   else
      status = "on"
   end
   sendStatus(status)
end

function controller.restart()
   sendOK()
   node.restart()
end

return function (connection, req, args)

   -- Make this work with both GET and POST methods.
   -- In the POST case, we need to extract the arguments.
   print("method is " .. req.method)
   local rd = req.getRequestData()
   if req.method == "POST" then
      local rd = req.getRequestData()
      for name, value in pairs(rd) do
         args[name] = value
      end
   end
   -- validate input

   context.connection = connection
   context.args = args 
   local status,err
   if (controller[args.action]) then
      context.driver,err = loadfile("SonoffDriver.lua")
      if context.driver then
         context.driver = context.driver()
      else
         sendStatus(err)
         return
      end

      status,err = pcall(controller[args.action])

      if not status then
         sendStatus(err)
      end
      return
   end

   -- everything else is error

   sendStatus("Bad action")

end
