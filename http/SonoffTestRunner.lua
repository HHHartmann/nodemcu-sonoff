if state == nil then
   state = {}
end

local function call(connection, func)

   if (state.err) then
      connection:send("error: "..state.err.."\n")
   end
   if (state.timer) then
      connection:send("timer active\n")
   end

   local status,err = pcall(func)

   if status then
         connection:send("Success\n")
   else
      connection:send("Failed: ")
      connection:send(err.."\n")
   end
   return status
end   


local function init()   
   node.compile("SonoffDriver.lua")
   node.compile("SonoffRunner.lua")
   node.compile("http/SonoffS20.lua")


   dofile("SonoffRunner.lua")
end


return function(connection, req, args)

   dofile("httpserver-header.lc")(connection, 200, 'txt')

   call(connection, function() loadfile("SonoffDriver.lua") end)

   call(connection, function() init() end)

   call(connection, function() dofile("http/SonoffS20.lua")(connection, req, args) end)

   call(connection, function() dofile("SonoffRunner.lua") end)

end