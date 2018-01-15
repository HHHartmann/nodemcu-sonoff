if state == nil then
   state = {}
end
local driver

local function buttonPressed(level, timestamp)
   state.err = nil
   _, state.err = pcall(function()
   state.button = level
   if level == gpio.LOW then
      state.timer = tmr.create()
      state.timer:register(7000, tmr.ALARM_SINGLE, node.restart)
      state.timer:start()
      driver.LedBlink(10,512)
   else
      if state.timer then
         state.timer:unregister()
         state.timer = nil
      end

      driver.ToggleRelay()
      
      driver.LedBlink(2,512)
   end
   end)
end

local function init()
   driver = dofile("SonoffDriver.lua")
   driver.OpenRelay()

   driver.LedBlink(2,512)
   
   driver.SetButtonCallback("both", buttonPressed)
end


init()
