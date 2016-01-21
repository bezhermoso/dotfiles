local timer = require "hs.timer"
local alert = require "hs.alert"
local notify = require "hs.notify"
local urlevent = require "hs.urlevent"

-- RAMEN TIMER --

-- Ramen timer to be triggered with hammerspoon://ramentime,
-- which is bound to an Alfred workflow
local function startRamenTimer()
  timer.doAfter(3 * 60, function ()
    notify.new({title="Ramen time!", informativeText="Your ramen is ready!"}):send()
  end)
  alert(" Ramen timer started! ")
end

urlevent.bind("ramentime", startRamenTimer)

-- END RAMEN TIMER --
