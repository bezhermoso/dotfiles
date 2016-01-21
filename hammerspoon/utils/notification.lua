local timer = require "hs.timer"

--Notification does not auto-withdraw if Hammerspoon is set to use "Alerts"
--in System Preferences > Notifications
local function withdrawAfter(sec, note)
  return timer.doAfter(sec, function() note:withdraw() end)
end

return {
  withdrawAfter = withdrawAfter
}
