local queue = {events{}}

function queue.setTime(now)
   queue.now = now
end

local function calculateFirstEvent(start, schedule)
   return start + ((now-start) % schedule
end

local function insert(firstTime, event)
   local i,v
   foreach i,v in pairs(queue.events) do
      if (i >= firstTime)
      
      end
   end
end

function queue.add(event)
--[[ The event must be like
{
	"schedule": 200     // time between the events
	"start": 500        // first time the event occurs
	"event":  whatever  // Data describint the event (just passed through)
}
--]]
   local first = calculateFirstEvent(event.start, event.schedule)
   insert(first, event)
end

